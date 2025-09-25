library;
import 'package:injectable/injectable.dart';

export 'src/product/entity/product.dart';
export 'src/product/repository/product_repository.dart';

@InjectableInit.microPackage()
initDomain() {}
