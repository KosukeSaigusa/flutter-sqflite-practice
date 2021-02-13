import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/appbar.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/main.dart';
import 'package:flutter_sqflite_practice/presentation/category/category_model.dart';
import 'package:flutter_sqflite_practice/presentation/category_add/category_add_page.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                //   child: Text(''),
                //   onPressed: () async {
                //     try {
                //       // await db.execute(
                //       //     'CREATE TABLE fixed_fees(id INTEGER PRIMARY KEY, name TEXT NOT_NULL, price INTEGER NOT_NULL, payment_cycle_id INTEGER NOT_NULL, note TEXT NOT_NUL, order_number INTEGER NOT_NULL)');
                //       // await db.execute('DROP TABLE fixed_fees');
                //       // await model.setFixedFees();
                //       print('実行完了');
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
                            children: _expenseCategoryCards(context),
                          )

                        /// 収入タブ
                        : model.currentTab == 1
                            ? Column(
                                children: _incomeCategoryCards(context),
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
                builder: (context) => CategoryAddPage(option: WriteOptions.add),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _expenseCategoryCards(BuildContext context) {
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
                  option: WriteOptions.update,
                  expenseCategory: model.expenseCategories[i],
                ),
                fullscreenDialog: true,
              ),
            );
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.all(marginMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: iconWidth,
                        child: Icon(
                          iconList[model.expenseCategories[i].iconId],
                          color: colorList[model.expenseCategories[i].colorId],
                        ),
                      ),
                      SizedBox(
                        width: marginMd,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width -
                            (marginSm * 2 +
                                marginMd * 4 +
                                iconWidth +
                                rightAlignedTextWidth),
                        child: Text(
                          '${model.expenseCategories[i].name}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        width: marginMd,
                      ),
                      Container(
                        width: rightAlignedTextWidth,
                        child: Text(
                          '予算：${model.expenseCategories[i].budget} 円'
                              .replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (m) => '${m[1]},'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: marginSm,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.year}年${model.month}月',
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: rightAlignedTextWidth,
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
                    ],
                  ),
                  SizedBox(
                    height: marginSm,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: greyColor,
                        width: MediaQuery.of(context).size.width -
                            (marginMd * 4 + rightAlignedTextWidth),
                        height: percentageBarHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.orange,
                              width: (MediaQuery.of(context).size.width -
                                      (marginMd * 4 + rightAlignedTextWidth)) *
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
                        width: marginMd,
                      ),
                      Container(
                        width: rightAlignedTextWidth,
                        child: Text(
                          '${(model.totalExpensesOfEachCategory[model.expenseCategories[i].id] / model.expenseCategories[i].budget * 100).toStringAsFixed(1)} %',
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
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

  List<Widget> _incomeCategoryCards(BuildContext context) {
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
                    option: WriteOptions.update,
                    incomeCategory: model.incomeCategories[i]),
                fullscreenDialog: true,
              ),
            );
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.all(marginMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: iconWidth,
                        child: Icon(
                          iconList[model.incomeCategories[i].iconId],
                          color: colorList[model.expenseCategories[i].colorId],
                        ),
                      ),
                      SizedBox(
                        width: marginMd,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width -
                            (marginSm * 2 + marginMd * 6),
                        child: Text(
                          '${model.incomeCategories[i].name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: marginSm,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.year}年${model.month}月',
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: rightAlignedTextWidth,
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
}
