import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/domain/expense.dart';
import 'package:flutter_sqflite_practice/domain/income.dart';
import 'package:flutter_sqflite_practice/main.dart';

class CalendarModel extends ChangeNotifier {
  CalendarModel() {
    expenseCategoryIdNameMap = {};
    expenseCategoryIdIconMap = {};
    incomeCategoryIdNameMap = {};
    incomeCategoryIdIconMap = {};
    expensesOfDayList = [];
    incomesOfDayList = [];
    totalExpensePricesOfEachDay = [];
    totalIncomePricesOfEachDay = [];
    year = DateTime.now().year;
    month = DateTime.now().month;
    date = DateTime.now().day;
    init();
  }

  Map expenseCategoryIdNameMap;
  Map expenseCategoryIdIconMap;
  Map incomeCategoryIdNameMap;
  Map incomeCategoryIdIconMap;
  List<Expense> expensesOfDayList;
  List<Income> incomesOfDayList;
  List<int> totalExpensePricesOfEachDay;
  List<int> totalIncomePricesOfEachDay;
  int year;
  int month;
  int date;

  Future<void> init() async {
    expensesOfDayList = await fetchExpensesOfDay(year, month, date);
    incomesOfDayList = await fetchIncomesOfDay(year, month, date);
    totalExpensePricesOfEachDay = await fetchExpensesOfMonth(year, month);
    totalIncomePricesOfEachDay = await fetchIncomesOfMonth(year, month);
    await createExpenseCategoryIdNameMap();
    await createExpenseCategoryIdIconMap();
    await createIncomeCategoryIdNameMap();
    await createIncomeCategoryIdIconMap();
    notifyListeners();
  }

  Future<void> showNextMonth() async {
    year = DateTime(year, month + 1).year;
    month = DateTime(year, month + 1).month;
    date = 1;
    expensesOfDayList = await fetchExpensesOfDay(year, month, date);
    incomesOfDayList = await fetchIncomesOfDay(year, month, date);
    totalExpensePricesOfEachDay = await fetchExpensesOfMonth(year, month);
    totalIncomePricesOfEachDay = await fetchIncomesOfMonth(year, month);
    notifyListeners();
  }

  Future<void> showPreviousMonth() async {
    year = DateTime(year, month - 1).year;
    month = DateTime(year, month - 1).month;
    date = 1;
    expensesOfDayList = await fetchExpensesOfDay(year, month, date);
    incomesOfDayList = await fetchIncomesOfDay(year, month, date);
    totalExpensePricesOfEachDay = await fetchExpensesOfMonth(year, month);
    totalIncomePricesOfEachDay = await fetchIncomesOfMonth(year, month);
    notifyListeners();
  }

  Future<void> tapDateCell(
      int tappedYear, int tappedMonth, int tappedDate) async {
    year = tappedYear;
    month = tappedMonth;
    date = tappedDate;
    expensesOfDayList = await fetchExpensesOfDay(year, month, date);
    incomesOfDayList = await fetchIncomesOfDay(year, month, date);
    notifyListeners();
  }

  Future<List<Expense>> fetchExpensesOfDay(year, month, date) async {
    // expenses テーブルの該当日のデータを取得するクエリ
    var maps = await db.query(
      'expenses',
      where: 'year = ? AND month = ? AND date = ?',
      whereArgs: [year, month, date],
    );
    var list = [];
    maps.forEach((element) {
      list.add(Expense(
        id: element['id'] as int,
        note: element['note'] as String,
        expenseCategoryId: element['expense_category_id'] as int,
        price: element['price'] as int,
        satisfaction: element['satisfaction'] as int,
        year: element['year'] as int,
        month: element['month'] as int,
        date: element['date'] as int,
      ));
    });
    return list.cast<Expense>();
  }

  Future<List<Income>> fetchIncomesOfDay(year, month, date) async {
    // incomes テーブルの該当日のデータを取得するクエリ
    var maps = await db.query(
      'incomes',
      where: 'year = ? AND month = ? AND date = ?',
      whereArgs: [year, month, date],
    );
    var list = [];
    maps.forEach((element) {
      list.add(Income(
        id: element['id'] as int,
        note: element['note'] as String,
        incomeCategoryId: element['income_category_id'] as int,
        price: element['price'] as int,
        year: element['year'] as int,
        month: element['month'] as int,
        date: element['date'] as int,
      ));
    });
    return list.cast<Income>();
  }

  Future<List<int>> fetchExpensesOfMonth(int year, int month) async {
    // 該当月の expenses データを取得するクエリ
    var maps = await db.query(
      'expenses',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
      orderBy: 'date',
    );
    var list = List.generate(DateTime(year, month + 1, 0).day, (i) => 0);
    maps.forEach((element) {
      list[(element['date'] as int) - 1] += (element['price'] as int);
    });
    return list;
  }

  Future<List<int>> fetchIncomesOfMonth(int year, int month) async {
    // 該当月の incomes データを取得するクエリ
    var maps = await db.query(
      'incomes',
      where: 'year = ? AND month = ?',
      whereArgs: [year, month],
      orderBy: 'date',
    );
    var list = List.generate(DateTime(year, month + 1, 0).day, (i) => 0);
    maps.forEach((element) {
      list[(element['date'] as int) - 1] += (element['price'] as int);
    });
    return list;
  }

  Future<void> createExpenseCategoryIdNameMap() async {
    var maps = await db.query('expense_categories');
    maps.forEach((element) {
      expenseCategoryIdNameMap[element['id'] as int] =
          element['name'] as String;
    });
    notifyListeners();
  }

  Future<void> createExpenseCategoryIdIconMap() async {
    var maps = await db.query('expense_categories');
    maps.forEach((element) {
      expenseCategoryIdIconMap[element['id'] as int] =
          iconList[element['icon_id'] as int];
    });
    notifyListeners();
  }

  Future<void> createIncomeCategoryIdNameMap() async {
    var maps = await db.query('income_categories');
    maps.forEach((element) {
      incomeCategoryIdNameMap[element['id'] as int] = element['name'] as String;
    });
    notifyListeners();
  }

  Future<void> createIncomeCategoryIdIconMap() async {
    var maps = await db.query('income_categories');
    maps.forEach((element) {
      incomeCategoryIdIconMap[element['id'] as int] =
          iconList[element['icon_id'] as int];
    });
    notifyListeners();
  }
}
