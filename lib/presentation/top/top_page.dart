import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/presentation/calendar/calendar_page.dart';
import 'package:flutter_sqflite_practice/presentation/category/category_page.dart';
import 'package:flutter_sqflite_practice/presentation/top/top_model.dart';
import 'package:provider/provider.dart';

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopModel>(
      create: (_) => TopModel(),
      child: Consumer<TopModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: _topPageBody(context),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: model.currentIndex,
              onTap: model.onTabTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'カレンダー',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money_sharp),
                  label: 'カテゴリー',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: '分析',
                ),
              ],
              selectedItemColor: Colors.amber[800],
            ),
          );
        },
      ),
    );
  }

  Widget _topPageBody(BuildContext context) {
    final model = Provider.of<TopModel>(context);
    final currentIndex = model.currentIndex;
    return Stack(
      children: <Widget>[
        _tabPage(currentIndex, 0, CalendarPage()),
        _tabPage(currentIndex, 1, CategoryPage()),
        _tabPage(currentIndex, 2, CalendarPage()),
      ],
    );
  }

  Widget _tabPage(int currentIndex, int tabIndex, StatelessWidget page) {
    return Visibility(
      visible: currentIndex == tabIndex,
      maintainState: true,
      child: page,
    );
  }
}
