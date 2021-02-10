import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/domain/expense.dart';
import 'package:flutter_sqflite_practice/domain/expense_category.dart';
import 'package:flutter_sqflite_practice/domain/income.dart';
import 'package:flutter_sqflite_practice/domain/income_category.dart';
import 'package:flutter_sqflite_practice/main.dart';

class ExpenseUpdateModel extends ChangeNotifier {
  ExpenseUpdateModel(Expense expense, Income income) {
    if (income == null) {
      currentTab = 0;
      year = expense.year;
      month = expense.month;
      date = expense.date;
      note = expense.note;
      price = expense.price;
      satisfaction = expense.satisfaction;
      expenseCategoryId = expense.expenseCategoryId;
      incomeCategoryId = null;
      expenseCategories = [];
      incomeCategories = [];
    }

    if (expense == null) {
      currentTab = 1;
      year = income.year;
      month = income.month;
      date = income.date;
      note = income.note;
      price = income.price;
      satisfaction = 3;
      expenseCategoryId = null;
      incomeCategoryId = income.incomeCategoryId;
      expenseCategories = [];
      incomeCategories = [];
    }

    isPriceValid = true;
    showPriceError = false;
    init();
  }

  int currentTab;
  int year;
  int month;
  int date;
  String note;
  int satisfaction;
  int price;
  int expenseCategoryId;
  int incomeCategoryId;
  List<ExpenseCategory> expenseCategories;
  List<IncomeCategory> incomeCategories;
  bool isPriceValid;
  bool showPriceError;

  Future<void> updateExpense() async {
    // final newExpense = Expense(
    //   note: note,
    //   expenseCategoryId: expenseCategoryId,
    //   price: price,
    //   satisfaction: satisfaction,
    //   year: year,
    //   month: month,
    //   date: date,
    // );
    // await Expense().insertExpense(newExpense);
    notifyListeners();
  }

  Future<void> updateIncome() async {
    // final newIncome = Income(
    //   note: note,
    //   incomeCategoryId: incomeCategoryId,
    //   price: price,
    //   year: year,
    //   month: month,
    //   date: date,
    // );
    // await Income().insertIncome(newIncome);
    notifyListeners();
  }

  Future<void> init() async {
    expenseCategories = await fetchExpenseCategories();
    incomeCategories = await fetchIncomeCategories();

    /// ToDo: カテゴリーの初期化処理
    /// 例）すでに該当カテゴリーが存在しない場合は null に戻す
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

  void showPreviousDay() {
    year = DateTime(year, month, date - 1).year;
    month = DateTime(year, month, date - 1).month;
    date = DateTime(year, month, date - 1).day;
    notifyListeners();
  }

  void showNextDay() {
    year = DateTime(year, month, date + 1).year;
    month = DateTime(year, month, date + 1).month;
    date = DateTime(year, month, date + 1).day;
    notifyListeners();
  }

  void changeNote(String text) {
    note = text;
    notifyListeners();
  }

  void changePrice(String text) {
    try {
      price = int.parse(text);
      isPriceValid = true;
      showPriceError = false;
    } catch (e) {
      print('数字以外の入力：');
      print(e);
      isPriceValid = false;
      showPriceError = true;
    }
    notifyListeners();
  }

  void changeSlider(double value) {
    satisfaction = value.toInt();
    notifyListeners();
  }

  void tapCategory(int tappedId) {
    if (currentTab == 0) {
      expenseCategoryId = tappedId;
    }
    if (currentTab == 1) {
      incomeCategoryId = tappedId;
    }
    notifyListeners();
  }
}
