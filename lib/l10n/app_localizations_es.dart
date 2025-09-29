// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Home Center';

  @override
  String get searchPlaceholder => 'Buscar productos';

  @override
  String get addToCart => 'Agregar';

  @override
  String get cartEmpty => 'Tu carrito está vacío';

  @override
  String get searchHint => 'Ingrese un término para buscar productos';

  @override
  String get searchNoResults => 'No se encontraron productos';

  @override
  String get cartTitle => 'Carrito';

  @override
  String get cartDeleteConfirmTitle => 'Confirmar eliminación';

  @override
  String cartDeleteConfirmContent(Object itemName) {
    return '¿Eliminar \"$itemName\" del carrito?';
  }

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String cartDeletedSnackbar(Object itemName) {
    return '\"$itemName\" eliminado';
  }

  @override
  String get cartNotSavedMessage =>
      'El item aún no está guardado en la base de datos';

  @override
  String cartQuantity(Object qty) {
    return 'Cantidad: $qty';
  }

  @override
  String noImageLabel(Object itemName) {
    return 'Imagen no disponible para $itemName';
  }

  @override
  String get priceNA => 'N/A';

  @override
  String get searchErrorFetching => 'Error al buscar productos';

  @override
  String get cartErrorLoading => 'Error al cargar el carrito';

  @override
  String get cartErrorAdding => 'Error al agregar el item al carrito';

  @override
  String get cartErrorRemoving => 'Error al eliminar el item del carrito';
}
