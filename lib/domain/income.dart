import 'package:flutter_sqflite_practice/main.dart';
import 'package:sqflite/sqflite.dart';

class Income {
  Income({
    this.id,
    this.note,
    this.incomeCategoryId,
    this.price,
    this.year,
    this.month,
    this.date,
  });

  final int id;
  final String note;
  final int incomeCategoryId;
  final int price;
  final int year;
  final int month;
  final int date;

  Future<void> insertIncome(Income income) async {
    await db.insert(
      'incomes',
      income.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateIncome(Income income) async {
    await db.update(
      'incomes',
      income.toMap(),
      where: 'id = ?',
      whereArgs: [income.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteIncome(Income income) async {
    await db.delete(
      'incomes',
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  // Income インスタンスを DB に保存する形式に変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'income_category_id': incomeCategoryId,
      'price': price,
      'year': year,
      'month': month,
      'date': date,
    };
  }
}
