import 'package:drift/native.dart';
import 'package:infrastructure/src/cart/app_database.dart';

/// Creates a new in-memory [AppDatabase] using Drift's NativeDatabase.memory().
/// Caller is responsible for closing the database when done.
AppDatabase createInMemoryDb() {
  final native = NativeDatabase.memory();
  return AppDatabase(native);
}
