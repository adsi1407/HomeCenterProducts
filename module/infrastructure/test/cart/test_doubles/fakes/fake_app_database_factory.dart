import 'package:drift/native.dart';
import 'package:infrastructure/src/cart/app_database.dart';

class FakeAppDatabaseFactory {
  static AppDatabase createInMemory() {
    final native = NativeDatabase.memory();
    return AppDatabase(native);
  }
}
