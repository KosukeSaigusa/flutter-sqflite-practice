import 'package:flutter_sqflite_practice/main.dart';
import 'package:sqflite/sql.dart';

class IncomeCategory {
  IncomeCategory({
    this.id,
    this.name,
    this.orderNumber,
    this.iconId,
    this.colorId,
  });

  final int id;
  final String name;
  final int orderNumber;
  final int iconId;
  final int colorId;

  Future<void> insertIncomeCategory(IncomeCategory incomeCategory) async {
    await db.insert(
      'income_categories',
      incomeCategory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateIncomeCategory(IncomeCategory incomeCategory) async {
    await db.update(
      'income_categories',
      incomeCategory.toMap(),
      where: 'id = ?',
      whereArgs: [incomeCategory.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteIncomeCategory(IncomeCategory incomeCategory) async {
    await db.delete(
      'income_categories',
      where: 'id = ?',
      whereArgs: [incomeCategory.id],
    );
  }

  // IncomeCategory インスタンスを DB に保存する形式に変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'order_number': orderNumber,
      'icon_id': iconId,
      'color_id': colorId,
    };
  }
}
