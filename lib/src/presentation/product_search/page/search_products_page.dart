import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/event/search_text_changed.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/event/search_load_more.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_error.dart';
import 'package:home_center_products/l10n/app_localizations.dart' as gen_l10n;
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_initial.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_loading.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/state/search_state.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/event/cart_add.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';
import 'package:home_center_products/src/presentation/cart_item/page/cart_page.dart';
import 'package:home_center_products/src/presentation/product_search/widgets/product_list_item.dart';
import 'package:domain/domain.dart';
import 'package:home_center_products/dependency_injection/dependency_injection.dart';

class SearchProductsPage extends StatefulWidget {
  const SearchProductsPage({super.key});

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  List<String> _fixedSuggestions = [];
  List<String> _fixedSuggestionsLower = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // try to load suggestions from DI use case; if not registered yet, ignore
    try {
      final usecase = getIt.get<GetSuggestionsUseCase>();
      usecase.call().then((list) {
        setState(() {
          _fixedSuggestions = list;
          _fixedSuggestionsLower = list.map((s) => s.toLowerCase()).toList();
        });
      });
    } catch (_) {
      // DI may not be generated in some environments; fallback to empty list
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = 200; // pixels from bottom to trigger load more
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (maxScroll - current <= threshold) {
      // dispatch load more
      context.read<SearchProductsBloc>().add(SearchLoadMore());
    }
  }

  void _onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<SearchProductsBloc>().add(SearchTextChanged(text));
    });
  }

  // Price formatting is handled by ProductListItem; keep page stateless regarding price format

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo_home_center.png', height: 32),
            const SizedBox(width: 8),
            const Text("Home Center"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CartPage()),
            ),
          ),
        ],
        // Suggestions in the AppBar bottom as chips (fixed list filtered by input)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              final text = value.text.trim();
              if (text.isEmpty) return const SizedBox.shrink();
              final lower = text.toLowerCase();
              // Use precomputed lowercase list to avoid allocations in build
              final matches = <String>[];
              for (var i = 0; i < _fixedSuggestions.length; i++) {
                if (_fixedSuggestionsLower.length > i && _fixedSuggestionsLower[i].contains(lower)) {
                  matches.add(_fixedSuggestions[i]);
                  if (matches.length >= 6) break; // limit chips to reduce rebuild cost
                }
              }

              if (matches.isEmpty) return const SizedBox.shrink();

              return Container(
                height: 56,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final s = matches[index];
                    return ActionChip(
                      label: Text(s),
                      onPressed: () {
                        _controller.text = s;
                        context.read<SearchProductsBloc>().add(SearchTextChanged(s));
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: matches.length,
                ),
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
                // (AppBar now shows the fixed suggestions as chips)
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchProductsBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return const Center(
                      child: Text("Ingrese un término para buscar productos"));
                } else if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  if (state.results.isEmpty) {
                    return const Center(child: Text("No se encontraron productos"));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: state.results.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.results.length) {
                        final product = state.results[index];
                        return ProductListItem(
                          product: product,
                          onAdd: () {
                            final cartItem = CartItem(
                              product: product,
                              quantity: 1,
                              addedAt: DateTime.now(),
                            );
                            context.read<CartBloc>().add(CartAdd(cartItem));
                          },
                        );
                      }
                      // loading footer
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  );
                } else if (state is SearchError) {
                  final localized = gen_l10n.AppLocalizations.of(context)?.searchErrorFetching;
                  return Center(child: Text(localized ?? state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
