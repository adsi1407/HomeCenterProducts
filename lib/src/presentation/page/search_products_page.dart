import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_center_products/src/presentation/bloc/event/search_text_changed.dart';
import 'package:home_center_products/src/presentation/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_error.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_initial.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_loaded.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_loading.dart';
import 'package:home_center_products/src/presentation/bloc/state/search_state.dart';

class SearchProductsPage extends StatelessWidget {
  const SearchProductsPage({super.key});

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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (text) =>
                  context.read<SearchProductsBloc>().add(SearchTextChanged(text)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final product = state.results[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            product.imageUrl ?? '',
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.name),
                          subtitle: Text("\$${product.price}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is SearchError) {
                  return Center(child: Text(state.message));
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