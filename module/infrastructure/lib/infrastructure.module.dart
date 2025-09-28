//@GeneratedMicroModule;InfrastructurePackageModule;package:infrastructure/infrastructure.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:dio/dio.dart' as _i361;
import 'package:domain/domain.dart' as _i494;
import 'package:infrastructure/dependency_injection/infrastructure_module.dart'
    as _i1037;
import 'package:infrastructure/src/cart/app_database.dart' as _i700;
import 'package:infrastructure/src/cart/cart_dao.dart' as _i1059;
import 'package:infrastructure/src/cart/cart_item_repository_drift.dart'
    as _i238;
import 'package:infrastructure/src/cart/cart_item_translator.dart' as _i754;
import 'package:infrastructure/src/product/product_api.dart' as _i672;
import 'package:infrastructure/src/product/product_cache.dart' as _i714;
import 'package:infrastructure/src/product/product_repository_api.dart'
    as _i408;
import 'package:infrastructure/src/product/product_repository_proxy.dart'
    as _i234;
import 'package:infrastructure/src/product/product_translator.dart' as _i105;
import 'package:injectable/injectable.dart' as _i526;

class InfrastructurePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final infrastructureModule = _$InfrastructureModule();
    await gh.factoryAsync<_i361.Dio>(
      () => infrastructureModule.dio(),
      preResolve: true,
    );
    await gh.factoryAsync<_i700.AppDatabase>(
      () => infrastructureModule.appDatabase(),
      preResolve: true,
    );
    gh.lazySingleton<_i754.CartItemTranslator>(
        () => const _i754.CartItemTranslator());
    gh.lazySingleton<_i714.ProductCache>(() => _i714.ProductCache());
    gh.lazySingleton<_i105.ProductTranslator>(() => _i105.ProductTranslator());
    gh.factory<_i1059.CartDao>(
        () => infrastructureModule.cartDao(gh<_i700.AppDatabase>()));
    gh.lazySingleton<_i672.ProductApi>(() => _i672.ProductApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i494.CartItemRepository>(
        () => _i238.CartItemRepositoryDrift(
              gh<_i1059.CartDao>(),
              gh<_i754.CartItemTranslator>(),
            ));
    gh.factory<_i408.ProductRepositoryApi>(() => _i408.ProductRepositoryApi(
          gh<_i672.ProductApi>(),
          gh<_i105.ProductTranslator>(),
        ));
    gh.factory<_i494.ProductRepository>(() => _i234.ProductRepositoryProxy(
          gh<_i408.ProductRepositoryApi>(),
          gh<_i714.ProductCache>(),
        ));
  }
}

class _$InfrastructureModule extends _i1037.InfrastructureModule {}
