import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  static Database _db;

  // Factory constructor
  factory DbProvider() {
    return DbProvider._();
  }

  // Generative constructor
  DbProvider._();

  Database getDB() {
    return _db;
  }

  Future<void> init() async {
    // Pathは sqflite の getDatabasePath() でも取得可能
    var documentDirectory = await getApplicationDocumentsDirectory();
    print(documentDirectory);
    final path = join(documentDirectory.path, 'expense.db');

    /// openDatabase(): DBインスタンスの取得
    _db = await openDatabase(
      path,
      version: 1,

      /// DB が path に存在しなかった場合に onCreate() が呼ばれ
      /// このタイミングで Table の生成などを行う
      /// db.execute: SQL 文の実行を行う
      /// DB に指定できるプロパティは
      /// INTEGER (int), TEXT (String), REAL (num), BLOB (List<int>) のみ
      onCreate: (newDb, version) async {
        print('===');
        print('openDatabase: onCreate called');

        /// expenses テーブル
        await newDb.execute(
            'CREATE TABLE expenses(id INTEGER PRIMARY KEY, note TEXT, expense_category_id INTEGER NOT_NULL, price INTEGER NOT_NULL, satisfaction INTEGER, year INTEGER NOT_NULL, month INTEGER NOT_NULL, date INTEGER NOT_NULL)');

        /// incomes テーブル
        await newDb.execute(
            'CREATE TABLE incomes(id INTEGER PRIMARY KEY, note TEXT, income_category_id INTEGER NOT_NULL, price INTEGER NOT_NULL, year INTEGER NOT_NULL, month INTEGER NOT_NULL, date INTEGER NOT_NULL)');

        /// expense_categories テーブル
        await newDb.execute(
            'CREATE TABLE expense_categories(id INTEGER PRIMARY KEY, name TEXT NOT_NULL, budget INTEGER, order_number INTEGER NOT_NULL, icon_id INTEGER NOT_NULL, color_id INTEGER NOT_NULL)');

        /// income_categories テーブル
        await newDb.execute(
            'CREATE TABLE income_categories(id INTEGER PRIMARY KEY, name TEXT NOT_NULL, order_number INTEGER NOT_NULL, icon_id INTEGER NOT_NULL, color_id INTEGER NOT_NULL)');
        print('openDatabase: Database created!');

        /// fixed_fees テーブル
        await newDb.execute(
            'CREATE TABLE fixed_fees(id INTEGER PRIMARY KEY, name TEXT NOT_NULL, price INTEGER NOT_NULL, order_number INTEGER NOT_NULL)');
        print('===');
      },
    );
  }
}
