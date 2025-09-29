// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Home Center';

  @override
  String get searchPlaceholder => 'Search products';

  @override
  String get addToCart => 'Add';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get searchErrorFetching => 'Error fetching products';

  @override
  String get cartErrorLoading => 'Error loading cart';

  @override
  String get cartErrorAdding => 'Error adding item to cart';

  @override
  String get cartErrorRemoving => 'Error removing item from cart';

  @override
  String get searchHint => 'Enter a term to search products';

  @override
  String get searchNoResults => 'No products found';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartDeleteConfirmTitle => 'Confirm deletion';

  @override
  String cartDeleteConfirmContent(String itemName) => 'Remove "$itemName" from cart?';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String cartDeletedSnackbar(String itemName) => '"$itemName" removed';

  @override
  String get cartNotSavedMessage => 'Item is not yet saved to the database';

  @override
  String cartQuantity(int qty) => 'Quantity: $qty';

  @override
  String noImageLabel(String itemName) => 'No image available for $itemName';

  @override
  String get priceNA => 'N/A';
}
