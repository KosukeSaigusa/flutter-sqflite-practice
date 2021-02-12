import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/domain/expense.dart';
import 'package:flutter_sqflite_practice/domain/expense_category.dart';
import 'package:flutter_sqflite_practice/domain/income.dart';
import 'package:flutter_sqflite_practice/domain/income_category.dart';
import 'package:flutter_sqflite_practice/main.dart';

class ExpenseAddModel extends ChangeNotifier {
  ExpenseAddModel(WriteOptions option, Expense expense, Income income, int year,
      int month, int date) {
    this.option = option;
    this.expense = expense;
    this.income = income;
    this.year = year;
    this.month = month;
    this.date = date;
    init();
  }

  WriteOptions option;
  Expense expense;
  Income income;
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

  Future<void> init() async {
    if (option == WriteOptions.add) {
      currentTab = 0;
      note = '';
      price = 0;
      satisfaction = 3;
      expenseCategoryId = null;
      incomeCategoryId = null;
      expenseCategories = [];
      incomeCategories = [];
      isPriceValid = false;
      showPriceError = false;
    }
    if (option == WriteOptions.update) {
      if (expense != null) {
        currentTab = 0;
        year = expense.year;
        month = expense.month;
        date = expense.date;
        note = expense.note;
        price = expense.price;
        satisfaction = expense.satisfaction;
        expenseCategoryId = null;
        incomeCategoryId = null;
        expenseCategories = [];
        incomeCategories = [];
        isPriceValid = true;
        showPriceError = false;
      }
      if (income != null) {
        currentTab = 1;
        year = income.year;
        month = income.month;
        date = income.date;
        note = income.note;
        price = income.price;
        satisfaction = null;
        expenseCategoryId = null;
        incomeCategoryId = null;
        expenseCategories = [];
        incomeCategories = [];
        isPriceValid = true;
        showPriceError = false;
      }
    }

    expenseCategories = await fetchExpenseCategories();
    incomeCategories = await fetchIncomeCategories();

    if (option == WriteOptions.add) {
      if (expenseCategories.isEmpty) {
        print('支出カテゴリーが未設定です');
      } else {
        expenseCategoryId = expenseCategories[0].id;
      }
      if (incomeCategories.isEmpty) {
        print('収入カテゴリーが未設定です');
      } else {
        incomeCategoryId = incomeCategories[0].id;
      }
    }
    if (option == WriteOptions.update) {
      if (expense != null) expenseCategoryId = expense.expenseCategoryId;
      if (income != null) incomeCategoryId = income.incomeCategoryId;
    }

    notifyListeners();
  }

  void tapExpenseTab() {
    if (option == WriteOptions.update) return;
    currentTab = 0;
    notifyListeners();
  }

  void tapIncomeTab() {
    if (option == WriteOptions.update) return;
    currentTab = 1;
    notifyListeners();
  }

  Future<void> addExpense() async {
    final newExpense = Expense(
      note: note,
      expenseCategoryId: expenseCategoryId,
      price: price,
      satisfaction: satisfaction,
      year: year,
      month: month,
      date: date,
    );
    await Expense().insertExpense(newExpense);
    notifyListeners();
  }

  Future<void> addIncome() async {
    final newIncome = Income(
      note: note,
      incomeCategoryId: incomeCategoryId,
      price: price,
      year: year,
      month: month,
      date: date,
    );
    await Income().insertIncome(newIncome);
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    final updatedExpense = Expense(
      id: expense.id,
      note: note,
      expenseCategoryId: expenseCategoryId,
      price: price,
      satisfaction: satisfaction,
      year: year,
      month: month,
      date: date,
    );
    await Expense().updateExpense(updatedExpense);
    notifyListeners();
  }

  Future<void> updateIncome(Income income) async {
    final updatedIncome = Income(
      id: income.id,
      note: note,
      incomeCategoryId: incomeCategoryId,
      price: price,
      year: year,
      month: month,
      date: date,
    );
    await Income().updateIncome(updatedIncome);
    notifyListeners();
  }

  Future<void> deleteExpense(Expense expense) async {
    await Expense().deleteExpense(expense);
    notifyListeners();
  }

  Future<void> deleteIncome(Income income) async {
    await Income().deleteIncome(income);
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

  Future<void> addExpenseCategory() async {
    // var list = [
    //   '食品・栄養',
    //   '外食・コンビニ',
    //   '備品・消耗品',
    //   '書籍・学習',
    //   '洋服・美容',
    //   '娯楽・交際費',
    //   '交通費',
    //   '臨時',
    // ];
    // for (var i = 0; i < list.length; i++) {
    //   final newExpenseCategory = ExpenseCategory(
    //     name: list[i],
    //     budget: 30000,
    //     orderNumber: i + 1,
    //     iconId: 0,
    //     colorId: 0,
    //   );
    //   await ExpenseCategory().insertExpenseCategory(newExpenseCategory);
    // }
    // notifyListeners();
  }

  Future<void> addIncomeCategory() async {
    // var list = [
    //   '給料',
    //   '副業',
    //   '臨時',
    // ];
    // for (var i = 0; i < list.length; i++) {
    //   final newIncomeCategory = IncomeCategory(
    //     name: list[i],
    //     orderNumber: i + 1,
    //     iconId: 0,
    //     colorId: 0,
    //   );
    //   await IncomeCategory().insertIncomeCategory(newIncomeCategory);
    // }
    // notifyListeners();
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
