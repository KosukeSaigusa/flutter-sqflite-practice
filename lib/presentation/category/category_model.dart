import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/domain/expense_category.dart';
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
