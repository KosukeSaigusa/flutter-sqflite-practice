import 'package:flutter_sqflite_practice/main.dart';
import 'package:sqflite/sql.dart';

class ExpenseCategory {
  ExpenseCategory({
    this.id,
    this.name,
    this.budget,
    this.orderNumber,
    this.iconId,
    this.colorId,
  });

  final int id;
  final String name;
  final int budget;
  final int orderNumber;
  final int iconId;
  final int colorId;

  Future<void> insertExpenseCategory(ExpenseCategory expenseCategory) async {
    await db.insert(
      'expense_categories',
      expenseCategory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ExpenseCategory インスタンスを DB に保存する形式に変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'budget': budget,
      'order_number': orderNumber,
      'icon_id': iconId,
      'color_id': colorId,
    };
  }
}
