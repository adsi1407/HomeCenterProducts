import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_center_products/l10n/app_localizations.dart';
import 'package:home_center_products/dependency_injection/dependency_injection.dart';
import 'package:home_center_products/src/presentation/product_search/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/cart_item/bloc/cart_bloc.dart';
import 'package:home_center_products/src/presentation/product_search/page/search_products_page.dart';
import 'package:infrastructure/infrastructure.dart' show AppDatabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // Close the AppDatabase when the widget is disposed to free resources.
    // Use tryGet to avoid throwing if it is not registered yet.
    try {
      final db = getIt.get<AppDatabase>();
      db.close();
    } catch (_) {
      // If AppDatabase is not registered yet or already closed, ignore.
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SearchProductsBloc>()),
        BlocProvider(create: (_) => getIt<CartBloc>()),
      ],
      child: MaterialApp(
        // Title will be localized via AppLocalizations
  onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SearchProductsPage(),
      ),
    );
  }
}
