//@GeneratedMicroModule;DomainPackageModule;package:domain/domain.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:domain/src/cart_item/repository/cart_item_repository.dart'
    as _i228;
import 'package:domain/src/cart_item/use_case/cart_item_use_case.dart' as _i733;
import 'package:domain/src/product/repository/product_repository.dart' as _i184;
import 'package:domain/src/product/use_case/search_products_use_case.dart'
    as _i931;
import 'package:domain/src/suggestion/repository/suggestion_repository.dart'
    as _i251;
import 'package:domain/src/suggestion/use_case/get_suggestions_use_case.dart'
    as _i698;
import 'package:injectable/injectable.dart' as _i526;

class DomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i698.GetSuggestionsUseCase>(
        () => _i698.GetSuggestionsUseCase(gh<_i251.SuggestionRepository>()));
    gh.factory<_i931.SearchProductsUseCase>(
        () => _i931.SearchProductsUseCase(gh<_i184.ProductRepository>()));
    gh.factory<_i733.CartItemUseCase>(
        () => _i733.CartItemUseCase(gh<_i228.CartItemRepository>()));
  }
}
