import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/db/db.dart';
import 'package:flutter_sqflite_practice/presentation/top/top_page.dart';
import 'package:sqflite/sqflite.dart';

/// 参考：
/// https://flutter.dev/docs/cookbook/persistence/sqlite

/// Global 変数として db を定義
DbProvider dbProvider;
Database db;

Future<void> main() async {
  // main()の中で非同期処理を行う際には、下記を実行
  WidgetsFlutterBinding.ensureInitialized();

  // DB クラスのインスタンス Factory Constructor で生成
  dbProvider = DbProvider();
  await dbProvider.init();
  db = dbProvider.getDB();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,

        /// スライダーのテーマ
        sliderTheme: SliderThemeData(
          valueIndicatorColor: greyColor,
          inactiveTickMarkColor: Colors.grey,
          activeTickMarkColor: Colors.orange,
          inactiveTrackColor: Colors.grey,
        ),
      ),
      // home: CalendarPage(),
      home: TopPage(),
    );
  }
}
