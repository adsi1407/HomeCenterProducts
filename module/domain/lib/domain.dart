library;
import 'package:injectable/injectable.dart';

// Domain public API barrel
// Group exports by concept for easier maintenance.

// Entities
export 'src/product/entity/product.dart';
export 'src/cart_item/entity/cart_item.dart';

// Repositories (interfaces)
export 'src/product/repository/product_repository.dart';
export 'src/cart_item/repository/cart_item_repository.dart';
export 'src/suggestion/repository/suggestion_repository.dart';

// Use cases
export 'src/product/use_case/search_products_use_case.dart';
export 'src/cart_item/use_case/cart_item_use_case.dart';
export 'src/suggestion/use_case/get_suggestions_use_case.dart';

@InjectableInit.microPackage()
initDomain() {}
