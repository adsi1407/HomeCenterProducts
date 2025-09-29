import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:infrastructure/src/cart/cart_dao.dart';
import 'package:infrastructure/src/cart/cart_item.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [CartItem], daos: [CartDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(NativeDatabase super.db);

  // bump this number if you change schema
  @override
  int get schemaVersion => 1;
}