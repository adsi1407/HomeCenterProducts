//@GeneratedMicroModule;InfrastructurePackageModule;package:infrastructure/infrastructure.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:dio/dio.dart' as _i361;
import 'package:domain/domain.dart' as _i494;
import 'package:infrastructure/dependency_injection/infrastructure_module.dart' as _i322;
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
    gh.lazySingleton<_i105.ProductTranslator>(() => _i105.ProductTranslator());
    gh.lazySingleton<_i672.ProductApi>(() => _i672.ProductApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i714.ProductCache>(
        () => _i714.ProductCache(defaultTtl: gh<Duration>()));
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

class _$InfrastructureModule extends _i322.InfrastructureModule {}
