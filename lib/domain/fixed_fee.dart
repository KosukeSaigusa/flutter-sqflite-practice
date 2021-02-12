import 'package:flutter_sqflite_practice/main.dart';
import 'package:sqflite/sql.dart';

class FixedFee {
  FixedFee({
    this.id,
    this.name,
    this.price,
    this.paymentCycleId,
    this.note,
    this.orderNumber,
  });

  final int id;
  final String name;
  final int price;
  final int paymentCycleId;
  final String note;
  final int orderNumber;

  Future<void> insertFixedFee(FixedFee fixedFee) async {
    await db.insert(
      'fixed_fees',
      fixedFee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateFixedFee(FixedFee fixedFee) async {
    await db.update(
      'fixed_fees',
      fixedFee.toMap(),
      where: 'id = ?',
      whereArgs: [fixedFee.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFixedFee(FixedFee fixedFee) async {
    await db.delete(
      'fixed_fees',
      where: 'id = ?',
      whereArgs: [fixedFee.id],
    );
  }

  // FixedFee インスタンスを DB に保存する形式に変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'payment_cycle_id': paymentCycleId,
      'note': note,
      'order_number': orderNumber,
    };
  }
}
