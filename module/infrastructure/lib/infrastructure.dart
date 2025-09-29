library;

/// Public exports for the infrastructure package.
export 'src/cart/app_database.dart';
export 'src/product/product_api.dart';

import 'package:injectable/injectable.dart';

@InjectableInit.microPackage()
void initInfrastructure() {}
