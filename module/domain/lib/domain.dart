library;
import 'package:injectable/injectable.dart';

export 'src/product/entity/product.dart';
export 'src/product/repository/product_repository.dart';
export 'src/product/use_case/search_products_use_case.dart';

@InjectableInit.microPackage()
initDomain() {}
