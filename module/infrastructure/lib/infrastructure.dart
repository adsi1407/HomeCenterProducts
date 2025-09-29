library;

/// Public exports for the infrastructure package.
export 'src/cart/app_database.dart';
// product_api is an internal implementation detail; export only what's public.

import 'package:injectable/injectable.dart';

@InjectableInit.microPackage()
void initInfrastructure() {}
