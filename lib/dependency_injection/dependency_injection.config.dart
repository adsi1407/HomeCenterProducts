// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:domain/domain.dart' as _i494;
import 'package:domain/domain.module.dart' as _i941;
import 'package:get_it/get_it.dart' as _i174;
import 'package:home_center_products/src/presentation/bloc/search_products_bloc.dart'
    as _i117;
import 'package:infrastructure/infrastructure.module.dart' as _i460;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i117.SearchProductsBloc>(
      () => _i117.SearchProductsBloc(gh<_i494.SearchProductsUseCase>()),
    );
    await _i460.InfrastructurePackageModule().init(gh);
    await _i941.DomainPackageModule().init(gh);
    return this;
  }
}
