import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_center_products/dependency_injection/dependency_injection.dart';
import 'package:home_center_products/src/presentation/bloc/search_products_bloc.dart';
import 'package:home_center_products/src/presentation/page/search_products_page.dart';

Future<void> main() async {
  await configureInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Center',
      home: BlocProvider(
        create: (_) => getIt<SearchProductsBloc>(),
        child: const SearchProductsPage(),
      ),
    );
  }
}
