import 'package:flutter_sqflite_practice/main.dart';
import 'package:sqflite/sql.dart';

class Expense {
  Expense({
    this.id,
    this.note,
    this.expenseCategoryId,
    this.price,
    this.satisfaction,
    this.year,
    this.month,
    this.date,
  });

  final int id;
  final String note;
  final int expenseCategoryId;
  final int price;
  final int satisfaction;
  final int year;
  final int month;
  final int date;

  Future<void> insertExpense(Expense expense) async {
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateExpense(Expense expense) async {
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteExpense(Expense expense) async {
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Expense インスタンスを DB に保存する形式に変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'expense_category_id': expenseCategoryId,
      'price': price,
      'satisfaction': satisfaction,
      'year': year,
      'month': month,
      'date': date,
    };
  }
}
