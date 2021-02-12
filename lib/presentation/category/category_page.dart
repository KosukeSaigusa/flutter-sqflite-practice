import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/appbar.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/presentation/category/category_model.dart';
import 'package:flutter_sqflite_practice/presentation/category_add/category_add_page.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _displayWidth = MediaQuery.of(context).size.width;
    const _paddingWidth = 8.0;
    const _rowMargin = 4.0;
    const _rightTextAreaWidth = 120.0;
    final _percentageBarWidth =
        _displayWidth - (_paddingWidth * 4 + _rightTextAreaWidth);
    const _percentageBarHeight = 17.2;
    return Scaffold(
      appBar: customAppBar,
      body: ChangeNotifierProvider<CategoryModel>(
        create: (_) => CategoryModel(),
        child: Consumer<CategoryModel>(
          builder: (context, model, child) {
            return Column(
              children: [
                Container(
                  color: greyColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48.0,
                        height: 48.0,
                      ),
                      Expanded(child: Container()),
                      Container(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                model.tapExpenseTab();
                              },
                              child: Container(
                                width: 75.0,
                                child: Center(
                                  child: Text(
                                    '支出',
                                    style: TextStyle(
                                      color: model.currentTab == 0
                                          ? Colors.white
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: model.currentTab == 0
                                      ? Colors.orange
                                      : null,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                model.tapIncomeTab();
                              },
                              child: Container(
                                width: 75.0,
                                child: Center(
                                  child: Text(
                                    '収入',
                                    style: TextStyle(
                                      color: model.currentTab == 0
                                          ? Colors.orange
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: model.currentTab == 0
                                      ? null
                                      : Colors.orange,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        width: 48.0,
                      ),
                    ],
                  ),
                ),
                // RaisedButton(
                //   child: Text('固定費テーブルを生成'),
                //   onPressed: () async {
                //     try {
                //       await db.execute(
                //           'CREATE TABLE fixed_fees(id INTEGER PRIMARY KEY, name TEXT NOT_NULL, price INTEGER NOT_NULL, order_number INTEGER NOT_NULL)');
                //     } catch (e) {
                //       print('エラー');
                //       print(e);
                //     }
                //   },
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: model.currentTab == 0
                        ? Column(
                            children: _expenseCategoryCards(
                                context,
                                _paddingWidth,
                                _rightTextAreaWidth,
                                _rowMargin,
                                _percentageBarWidth,
                                _percentageBarHeight),
                          )

                        /// 収入タブ
                        : model.currentTab == 1
                            ? Column(
                                children: _incomeCategoryCards(
                                    context,
                                    _paddingWidth,
                                    _rightTextAreaWidth,
                                    _rowMargin,
                                    _percentageBarWidth,
                                    _percentageBarHeight),
                              )
                            : SizedBox(),
                  ),
                ),
              ],
            );
          },
        ),
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
                builder: (context) => CategoryAddPage(WriteOptions.add),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _expenseCategoryCards(
      BuildContext context,
      double _paddingWidth,
      double _rightTextAreaWidth,
      double _rowMargin,
      double _percentageBarWidth,
      double _percentageBarHeight) {
    final model = Provider.of<CategoryModel>(context);
    var list = [];
    for (var i = 0; i < model.expenseCategories.length; i++) {
      list.add(
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryAddPage(
                    WriteOptions.update, model.expenseCategories[i], null),
                fullscreenDialog: true,
              ),
            );
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.only(
                top: _paddingWidth,
                bottom: _paddingWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Icon(
                        iconList[model.expenseCategories[i].iconId],
                        color: colorList[model.expenseCategories[i].colorId],
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Text('${model.expenseCategories[i].name}'),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: _rightTextAreaWidth,
                        child: Text(
                          '予算：${model.expenseCategories[i].budget} 円'
                              .replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (m) => '${m[1]},'),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _rowMargin,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Text(
                        '${model.year}年${model.month}月',
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: _rightTextAreaWidth,
                        child: Text(
                          '実績：${model.totalExpensesOfEachCategory[model.expenseCategories[i].id]} 円'
                              .replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (m) => '${m[1]},'),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _rowMargin,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Container(
                        color: greyColor,
                        width: _percentageBarWidth,
                        height: _percentageBarHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.orange,
                              width: _percentageBarWidth *
                                  model.totalExpensesOfEachCategory[
                                      model.expenseCategories[i].id] /
                                  model.expenseCategories[i].budget,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Container(
                        width: _rightTextAreaWidth,
                        child: Text(
                          '${(model.totalExpensesOfEachCategory[model.expenseCategories[i].id] / model.expenseCategories[i].budget * 100).toStringAsFixed(1)} %',
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return list.cast<Widget>();
  }

  List<Widget> _incomeCategoryCards(
      BuildContext context,
      double _paddingWidth,
      double _rightTextAreaWidth,
      double _rowMargin,
      double _percentageBarWidth,
      double _percentageBarHeight) {
    final model = Provider.of<CategoryModel>(context);
    var list = [];
    for (var i = 0; i < model.incomeCategories.length; i++) {
      list.add(
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryAddPage(
                    WriteOptions.update, null, model.incomeCategories[i]),
                fullscreenDialog: true,
              ),
            );
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.only(
                top: _paddingWidth,
                bottom: _paddingWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Icon(
                        iconList[model.incomeCategories[i].iconId],
                        color: colorList[model.expenseCategories[i].colorId],
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Text('${model.incomeCategories[i].name}'),
                    ],
                  ),
                  SizedBox(
                    height: _rowMargin,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Text(
                        '${model.year}年${model.month}月',
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: _rightTextAreaWidth,
                        child: Text(
                          '実績：${model.totalIncomesOfEachCategory[model.incomeCategories[i].id]} 円'
                              .replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (m) => '${m[1]},'),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _rowMargin,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return list.cast<Widget>();
  }
}
