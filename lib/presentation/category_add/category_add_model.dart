import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/domain/expense_category.dart';
import 'package:flutter_sqflite_practice/domain/income_category.dart';

class CategoryAddModel extends ChangeNotifier {
  CategoryAddModel(WriteOptions option, ExpenseCategory expenseCategory,
      IncomeCategory incomeCategory) {
    this.option = option;
    this.expenseCategory = expenseCategory;
    this.incomeCategory = incomeCategory;
    init();
    notifyListeners();
  }

  WriteOptions option;
  ExpenseCategory expenseCategory;
  IncomeCategory incomeCategory;
  int currentTab;
  String name;
  int budget;
  int iconId;
  int colorId;
  Color iconColor;
  bool isNameValid;
  bool isBudgetValid;
  bool showNameError;
  bool showBudgetError;

  void init() {
    if (option == WriteOptions.add) {
      currentTab = 0;
      name = '';
      budget = 0;
      iconId = 0;
      colorId = 0;
      iconColor = colorList[0];
      isNameValid = false;
      isBudgetValid = false;
      showNameError = false;
      showBudgetError = false;
    }
    if (option == WriteOptions.update) {
      if (expenseCategory != null) {
        currentTab = 0;
        name = expenseCategory.name;
        budget = expenseCategory.budget;
        iconId = expenseCategory.iconId;
        colorId = expenseCategory.colorId;
        iconColor = colorList[colorId];
        isNameValid = true;
        isBudgetValid = true;
        showNameError = false;
        showBudgetError = false;
      }
      if (incomeCategory != null) {
        currentTab = 1;
        name = incomeCategory.name;
        iconId = incomeCategory.iconId;
        colorId = incomeCategory.colorId;
        iconColor = colorList[colorId];
        isNameValid = true;
        isBudgetValid = false;
        showNameError = false;
        showBudgetError = false;
      }
      showNameError = false;
    }
  }

  Future<void> addExpenseCategory() async {
    final newExpenseCategory = ExpenseCategory(
      name: name,
      budget: budget,
      iconId: iconId,
      colorId: colorId,
    );
    await ExpenseCategory().insertExpenseCategory(newExpenseCategory);
    notifyListeners();
  }

  Future<void> addIncomeCategory() async {
    final newIncomeCategory = IncomeCategory(
      name: name,
      iconId: iconId,
      colorId: colorId,
    );
    await IncomeCategory().insertIncomeCategory(newIncomeCategory);
    notifyListeners();
  }

  Future<void> updateExpenseCategory() async {
    final updatedExpenseCategory = ExpenseCategory(
      id: expenseCategory.id,
      name: name,
      budget: budget,
      iconId: iconId,
      colorId: colorId,
    );
    await ExpenseCategory().updateExpenseCategory(updatedExpenseCategory);
    notifyListeners();
  }

  Future<void> updateIncomeCategory() async {
    final updatedIncomeCategory = IncomeCategory(
      id: incomeCategory.id,
      name: name,
      iconId: iconId,
      colorId: colorId,
    );
    await IncomeCategory().updateIncomeCategory(updatedIncomeCategory);
    notifyListeners();
  }

  Future<void> deleteExpenseCategory() async {
    await ExpenseCategory().deleteExpenseCategory(expenseCategory);
    notifyListeners();
  }

  Future<void> deleteIncomeCategory() async {
    await IncomeCategory().deleteIncomeCategory(incomeCategory);
    notifyListeners();
  }

  void tapIcon(int count) {
    iconId = count;
    notifyListeners();
  }

  void tapColor(int count) {
    colorId = count;
    iconColor = colorList[count];
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

  void changeName(String text) {
    if (text.isEmpty) {
      name = text;
      isNameValid = false;
      showNameError = true;
    } else if (text.length > 100) {
      name = text;
      isNameValid = false;
      showNameError = true;
    } else {
      name = text;
      isNameValid = true;
      showNameError = false;
    }
    notifyListeners();
  }

  void changeBudget(String text) {
    try {
      budget = int.parse(text);
      isBudgetValid = true;
      showBudgetError = false;
    } catch (e) {
      print('数字以外の入力：');
      print(e);
      isBudgetValid = false;
      showBudgetError = true;
    }
    notifyListeners();
  }
}
