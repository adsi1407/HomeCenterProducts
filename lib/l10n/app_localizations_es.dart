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
}
