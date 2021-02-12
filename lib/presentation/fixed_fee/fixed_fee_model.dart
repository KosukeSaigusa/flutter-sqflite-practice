import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/domain/fixed_fee.dart';
import 'package:flutter_sqflite_practice/main.dart';

class FixedFeeModel extends ChangeNotifier {
  FixedFeeModel() {
    fixedFees = [];
    init();
  }

  List<FixedFee> fixedFees;

  Future<void> init() async {
    fixedFees = await fetchFixedFees();
  }

  Future<List<FixedFee>> fetchFixedFees() async {
    // fixed_fees テーブルの全データを取得するクエリ
    var maps = await db.query('fixed_fees');
    var list = [];
    maps.forEach((element) {
      list.add(FixedFee(
        id: element['id'] as int,
        name: element['name'] as String,
        price: element['price'] as int,
        paymentCycleId: element['payment_cycle_id'] as int,
        note: element['note'] as String,
        orderNumber: element['order_number'] as int,
      ));
    });
    return list.cast<FixedFee>();
  }
}
