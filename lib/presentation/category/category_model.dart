import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/domain/expense_category.dart';
import 'package:flutter_sqflite_practice/domain/fixed_fee.dart';
import 'package:flutter_sqflite_practice/domain/income_category.dart';
import 'package:flutter_sqflite_practice/main.dart';

class CategoryModel extends ChangeNotifier {
  CategoryModel() {
    currentTab = 0;
    year = DateTime.now().year;
    month = DateTime.now().month;
    date = DateTime.now().day;
    expenseCategories = [];
    incomeCategories = [];
    totalExpensesOfEachCategory = {};
    totalIncomesOfEachCategory = {};
    init();
  }

  int currentTab;
  int year;
  int month;
  int date;
  List<ExpenseCategory> expenseCategories;
  List<IncomeCategory> incomeCategories;
  Map<int, int> totalExpensesOfEachCategory;
  Map<int, int> totalIncomesOfEachCategory;

  Future<void> setFixedFees() async {
    // var list = [
    //   {
    //     'name': '家賃',
    //     'price': 63860,
    //     'payment_cycle_id': 1,
    //     'note': '',
    //   },
    //   {
    //     'name': '電気',
    //     'price': 4000,
    //     'payment_cycle_id': 1,
    //     'note': '',
    //   },
    //   {
    //     'name': 'ガス',
    //     'price': 4000,
    //     'payment_cycle_id': 1,
    //     'note': '',
    //   },
    //   {
    //     'name': '水道',
    //     'price': 4000,
    //     'payment_cycle_id': 2,
    //     'note': '',
    //   },
    //   {
    //     'name': 'LINE モバイル',
    //     'price': 2000,
    //     'payment_cycle_id': 1,
    //     'note': '',
    //   },
    //   {
    //     'name': '美容院',
    //     'price': 5500,
    //     'payment_cycle_id': 1,
    //     'note': '',
    //   },
    //   {
    //     'name': 'Flutter 大学',
    //     'price': 2200,
    //     'payment_cycle_id': 1,
    //     'note': '',
    //   },
    //   {
    //     'name': 'YouTube Premium',
    //     'price': 0,
    //     'payment_cycle_id': 1,
    //     'note': '',
    //   },
    //   {
    //     'name': 'Amazon Gold カード',
    //     'price': 4400,
    //     'payment_cycle_id': 12,
    //     'note':
    //         '加入日：2019年6月5日。年会費の支払いは毎年7月の請求。元の11,000円から、マイペイリスボで5,500円、Web 明細で1,100円の割引により、合計4,400円。',
    //   },
    //   {
    //     'name': 'Apple Developer Program',
    //     'price': 12980,
    //     'payment_cycle_id': 12,
    //     'note': '加入日：2020年9月5日。11,800円+税 = 12,980円'
    //   },
    //   {
    //     'name': '1Password',
    //     'price': 4500,
    //     'payment_cycle_id': 12,
    //     'note': '支払日：毎年5月24日。2.99ドル/月（年払い）× 12ヶ月 × 1.10（消費税） = 39.47ドル ≒ 4500円'
    //   },
    //   {
    //     'name': 'Google Domains (kosukesaigusa.com)',
    //     'price': 1540,
    //     'payment_cycle_id': 12,
    //     'note': '毎年1月30日に更新。1,400円+税 = 1,540円'
    //   },
    // ];
    // for (var i = 0; i < list.length; i++) {
    //   final newFixedFee = FixedFee(
    //     name: list[i]['name'] as String,
    //     price: list[i]['price'] as int,
    //     paymentCycleId: list[i]['payment_cycle_id'] as int,
    //     note: list[i]['note'] as String,
    //     orderNumber: i + 1,
    //   );
    //   await FixedFee().insertFixedFee(newFixedFee);
    // }
  }

  Future<void> init() async {
    expenseCategories = await fetchExpenseCategories();
    incomeCategories = await fetchIncomeCategories();
    totalExpensesOfEachCategory =
        await calcTotalExpensesOfEachCategory(year, month);
    totalIncomesOfEachCategory =
        await calcTotalIncomesOfEachCategory(year, month);
  }

  void tapExpenseTab() {
    currentTab = 0;
    notifyListeners();
  }

  void tapIncomeTab() {
    currentTab = 1;
    notifyListeners();
  }

  Future<List<ExpenseCategory>> fetchExpenseCategories() async {
    // expense_categories テーブルの全データを取得するクエリ
    var maps = await db.query('expense_categories');
    var list = [];
    maps.forEach((element) {
      list.add(ExpenseCategory(
        id: element['id'] as int,
        name: element['name'] as String,
        budget: element['budget'] as int,
        orderNumber: element['order_number'] as int,
        iconId: element['icon_id'] as int,
        colorId: element['color_id'] as int,
      ));
    });
    return list.cast<ExpenseCategory>();
  }

  Future<List<IncomeCategory>> fetchIncomeCategories() async {
    // income_categories テーブルの全データを取得するクエリ
    var maps = await db.query('income_categories');
    var list = [];
    maps.forEach((element) {
      list.add(IncomeCategory(
        id: element['id'] as int,
        name: element['name'] as String,
        orderNumber: element['order_number'] as int,
        iconId: element['icon_id'] as int,
        colorId: element['color_id'] as int,
      ));
    });
    return list.cast<IncomeCategory>();
  }

  Future<Map<int, int>> calcTotalExpensesOfEachCategory(year, month) async {
    // expense_categories テーブルの全データを取得するクエリ
    var _categories = await db.query('expense_categories', orderBy: 'id');
    var _expenses = await db.query(
      'expenses',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
    );

    // int(key): int(value) の Map
    var _categoryIdTotalExpenseMap = {};
    _categories.forEach((element) {
      _categoryIdTotalExpenseMap[element['id']] = 0;
    });

    _expenses.forEach((element) {
      _categoryIdTotalExpenseMap[element['expense_category_id']] +=
          element['price'];
    });

    return _categoryIdTotalExpenseMap.cast<int, int>();
  }

  Future<Map<int, int>> calcTotalIncomesOfEachCategory(year, month) async {
    // income_categories テーブルの全データを取得するクエリ
    var _categories = await db.query('income_categories', orderBy: 'id');
    var _incomes = await db.query(
      'incomes',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
    );

    // int(key): int(value) の Map
    var _categoryIdTotalIncomeMap = {};
    _categories.forEach((element) {
      _categoryIdTotalIncomeMap[element['id']] = 0;
    });

    _incomes.forEach((element) {
      _categoryIdTotalIncomeMap[element['income_category_id']] +=
          element['price'];
    });

    return _categoryIdTotalIncomeMap.cast<int, int>();
  }
}
