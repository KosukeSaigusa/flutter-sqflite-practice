import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/appbar.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/common/weekday.dart';
import 'package:flutter_sqflite_practice/main.dart';
import 'package:flutter_sqflite_practice/presentation/calendar/calendar_model.dart';
import 'package:flutter_sqflite_practice/presentation/expense_add/expense_add_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<CalendarModel>(
      create: (_) => CalendarModel(),
      child: Consumer<CalendarModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: customAppBar,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: greyColor,
                  child: Column(
                    children: [
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await exportToCSV();
                      //   },
                      //   child: Text('CSV に出力する'),
                      // ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    '固定費：',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Text(
                                  //   '106663 円'.replaceAllMapped(
                                  //       RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  //       (m) => '${m[1]},'),
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  Text('未登録'),
                                  // ElevatedButton(
                                  ElevatedButton(
                                    onPressed: () async {
                                      // await db.execute(
                                      //     'CREATE TABLE fixed_fees(id INTEGER PRIMARY KEY, name TEXT NOT_NULL, price INTEGER NOT_NULL, order_number INTEGER NOT_NULL)');
                                    },
                                    child: Text('固定費を登録する'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: 4.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Container(
                              child: Text(
                                '合計支出：${model.totalExpenseOfMonth} 円'
                                    .replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (m) => '${m[1]},'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 48.0),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () async {
                                await model.showPreviousMonth();
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(4.0),
                              width: 150,
                              color: selectedColor,
                              child: Center(
                                child: Text(
                                  '${model.year}年 ${model.month}月',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () async {
                                await model.showNextMonth();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        width: 48.0,
                        child: IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: greyColor,
                  height: 10,
                  thickness: 1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: daysOfWeek.map((day) {
                        return Expanded(
                          child: Container(
                            color: greyColor,
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    _calendar(context),
                  ],
                ),
                const Divider(
                  color: greyColor,
                  height: 20,
                  thickness: 1,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: _width,
                              padding: EdgeInsets.only(left: 8.0),
                              color: greyColor,
                              child: Text(
                                '${model.year}年${model.month}月${model.date}日(${japaneseWeekday(model.year, model.month, model.date)})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        model.incomesOfEachDay.isEmpty
                            ? SizedBox()
                            : Container(
                                padding: EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < model.incomesOfEachDay.length;
                                        i++)
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExpenseAddPage(
                                                            option: WriteOptions
                                                                .update,
                                                            income: model
                                                                .incomesOfEachDay[i]),
                                                    fullscreenDialog: true,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  top: 4.0,
                                                  bottom: 4.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(model.incomeCategoryIdIconMap[model
                                                            .incomesOfEachDay[i]
                                                            .incomeCategoryId]
                                                        as IconData),
                                                    SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '${model.incomeCategoryIdNameMap[model.incomesOfEachDay[i].incomeCategoryId]}',
                                                        style: smTextStyle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                          '：${model.incomesOfEachDay[i].note}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: smTextStyle,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 80,
                                                      child: Text(
                                                        '${model.incomesOfEachDay[i].price} 円'
                                                            .replaceAllMapped(
                                                                RegExp(
                                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                (m) =>
                                                                    '${m[1]},'),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              color: greyColor,
                                              height: 5,
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                        model.expensesOfEachDay.isEmpty
                            ? SizedBox()
                            : Container(
                                padding: EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < model.expensesOfEachDay.length;
                                        i++)
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExpenseAddPage(
                                                            option: WriteOptions
                                                                .update,
                                                            expense: model
                                                                .expensesOfEachDay[i]),
                                                    fullscreenDialog: true,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  top: 4.0,
                                                  bottom: 4.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(model.expenseCategoryIdIconMap[model
                                                            .expensesOfEachDay[i]
                                                            .expenseCategoryId]
                                                        as IconData),
                                                    SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '${model.expenseCategoryIdNameMap[model.expensesOfEachDay[i].expenseCategoryId]}',
                                                        style: smTextStyle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                          '：${model.expensesOfEachDay[i].note}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: smTextStyle,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Icon(
                                                          Icons.star_border,
                                                          color:
                                                              Colors.amber[600],
                                                          size: 18.0,
                                                        ),
                                                        SizedBox(width: 2.0),
                                                        Text(
                                                          '${model.expensesOfEachDay[i].satisfaction}',
                                                          style: smTextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    Container(
                                                      width: 80,
                                                      child: Text(
                                                        '${model.expensesOfEachDay[i].price} 円'
                                                            .replaceAllMapped(
                                                                RegExp(
                                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                (m) =>
                                                                    '${m[1]},'),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              color: greyColor,
                                              height: 5,
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                ),
              ],
            ),
            floatingActionButton: Container(
              width: 56.0,
              height: 56.0,
              child: RaisedButton(
                child: Icon(Icons.add, color: Colors.white),
                color: Colors.orange,
                shape: const CircleBorder(),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseAddPage(
                          option: WriteOptions.add,
                          year: model.year,
                          month: model.month,
                          date: model.date),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// DB のバックアップ (CSV) のとり方
  /// iTerm2 で `flutter run --debug` を実行
  /// 実機の iPhone を選択
  /// 下記の処理を実行し、実行結果のテキストをコピー
  /// コンマ区切りの文字列をタブを変換するなどしてよしなに CSV として保存
  Future<void> exportToCSV() async {
    final tables = <String>[
      'expenses',
      'incomes',
      'expense_categories',
      'income_categories',
      'fixed_fees',
    ];
    final now = DateTime.now();
    final dir = await getApplicationDocumentsDirectory();
    print('path: ${dir.path}');
    for (var i = 0; i < tables.length; i++) {
      final result = await db.query(tables[i]);
      // final filename = '${dir.path}/${tables[i]}_${now.toIso8601String()}.csv';
      // await File(filename).writeAsString(mapListToCsv(result));
      debugPrint('===');
      print('table: ${tables[i]}');
      debugPrint(mapListToCsv(result));
    }
  }

  /// Convert a map list to csv
  String mapListToCsv(List<Map<String, dynamic>> mapList,
      {ListToCsvConverter converter}) {
    if (mapList == null) {
      return null;
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List<dynamic>.filled(keyIndexMap.length, null);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[keys, ...data]);
  }

  Widget _calendar(BuildContext context) {
    final model = Provider.of<CalendarModel>(context);
    var numRows = 5;
    var finalDate = DateTime(model.year, model.month + 1, 0).day;
    var weekday = DateTime(model.year, model.month, 1).weekday;
    if (weekday == 0) weekday = 7;
    var standard = finalDate + weekday - 1;
    if (standard == 28) {
      numRows = 4;
    } else if (standard > 28 && standard <= 35) {
      numRows = 5;
    } else {
      numRows = 6;
    }

    var dateList = _dateList(numRows, model.year, model.month);
    var list = [];
    for (var i = 0; i < numRows; i++) {
      list.add(
        Row(
          children: [
            for (int j = 0; j < 7; j++) _dateCell(context, dateList[7 * i + j])
          ],
        ),
      );
    }
    return Column(
      children: list.cast<Widget>(),
    );
  }

  List<int> _dateList(int numRows, int year, int month) {
    var list = List.generate(numRows * 7, (i) => 0);
    var weekday = DateTime(year, month, 1).weekday;
    var finalDate = DateTime(year, month + 1, 0).day;
    var j = 0;
    for (var i = 0; i < numRows * 7; i++) {
      if (j < finalDate) {
        list[weekday - 1 + i] = i + 1;
        j++;
      }
    }
    return list;
  }

  /// 日付を表示するセル
  Widget _dateCell(
    BuildContext context,
    int dateElement,
  ) {
    final model = Provider.of<CalendarModel>(context);
    return Expanded(
      child: InkWell(
        onTap: dateElement == 0
            ? null
            : () {
                model.tapDateCell(model.year, model.month, dateElement);
              },
        child: Container(
          color: dateElement == model.date ? selectedColor : Colors.transparent,
          height: dateCellHeight,
          child: DecoratedBox(
            /// カレンダーのセルを可視化するボーダー
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: greyColor, width: 1),
                right: BorderSide(color: greyColor, width: 1),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(
                top: 2.0,
                left: 4.0,
                right: 2.0,
                bottom: 2.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      /// カレンダーの日付
                      dateElement == 0
                          ? SizedBox()
                          : Text(
                              '$dateElement',
                              style: TextStyle(
                                fontSize: 10.0,
                              ),
                            ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            dateElement == 0
                                ? SizedBox()
                                : model.totalIncomePricesOfEachDay.isEmpty
                                    ? Text(
                                        '',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.blue,
                                        ),
                                      )
                                    : model.totalIncomePricesOfEachDay[
                                                dateElement - 1] ==
                                            0
                                        ? Text('')
                                        : Text(
                                            '${model.totalIncomePricesOfEachDay[dateElement - 1]}'
                                                .replaceAllMapped(
                                                    RegExp(
                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                    (m) => '${m[1]},'),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.blue,
                                            ),
                                          ),
                            dateElement == 0
                                ? SizedBox()
                                : model.totalExpensePricesOfEachDay.isEmpty
                                    ? Text(
                                        '',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      )
                                    : model.totalExpensePricesOfEachDay[
                                                dateElement - 1] ==
                                            0
                                        ? Text('')
                                        : Text(
                                            '${model.totalExpensePricesOfEachDay[dateElement - 1]}'
                                                .replaceAllMapped(
                                                    RegExp(
                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                    (m) => '${m[1]},'),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.red[300],
                                            ),
                                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
