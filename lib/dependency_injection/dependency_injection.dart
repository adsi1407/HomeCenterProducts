import 'package:domain/domain.module.dart';
import 'package:get_it/get_it.dart';
import 'package:home_center_products/dependency_injection/dependency_injection.config.dart';
import 'package:infrastructure/infrastructure.module.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesAfter: [
    ExternalModule(InfrastructurePackageModule),
    ExternalModule(DomainPackageModule)
  ],
)
void configureInjection() => getIt.init();