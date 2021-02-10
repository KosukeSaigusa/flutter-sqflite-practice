import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/common/weekday.dart';
import 'package:flutter_sqflite_practice/domain/expense.dart';
import 'package:flutter_sqflite_practice/presentation/calendar/calendar_page.dart';
import 'package:flutter_sqflite_practice/presentation/expense_update/expense_update_model.dart';
import 'package:provider/provider.dart';

class ExpenseUpdatePage extends StatelessWidget {
  ExpenseUpdatePage(this.expense);
  final Expense expense;
  @override
  Widget build(BuildContext context) {
    final _displayWidth = MediaQuery.of(context).size.width;
    const _labelWidth = 60.0;
    const _paddingWidth = 8.0;
    const _iconWidth = 16.0;
    const _textFormHeight = 36.0;
    const _satisfactionLabelWidth = 15.0;
    return Scaffold(
      body: ChangeNotifierProvider<ExpenseUpdateModel>(
        create: (_) => ExpenseUpdateModel(expense),
        child: Consumer<ExpenseUpdateModel>(
          builder: (context, model, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: greyColor,
                  height: appBarHeight,
                ),
                Container(
                  color: greyColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48.0,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            model.currentTab == 0
                                ? Container(
                                    width: 75.0,
                                    child: Center(
                                      child: Text(
                                        '支出',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            model.currentTab == 1
                                ? Container(
                                    width: 75.0,
                                    child: Center(
                                      child: Text(
                                        '収入',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
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
                        child: IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () {
                            print('削除するよ');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _paddingWidth,
                ),
                Container(
                  height: _textFormHeight,
                  padding: EdgeInsets.only(
                    left: _paddingWidth,
                    right: _paddingWidth,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _labelWidth,
                        child: Text('日付'),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Container(
                        height: _iconWidth,
                        width: _iconWidth,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: _iconWidth,
                          ),
                          onPressed: () {
                            model.showPreviousDay();
                          },
                        ),
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Container(
                        width: _displayWidth -
                            (_labelWidth + _iconWidth * 2 + _paddingWidth * 5),
                        color: Colors.amber[100],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Center(
                                child: Text(
                                  '${model.year}年${model.month}月${model.date}日(${japaneseWeekday(model.year, model.month, model.date)})',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Container(
                        height: 16.0,
                        width: 16.0,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                          ),
                          onPressed: () {
                            model.showNextDay();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: greyColor,
                  height: 5,
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: _paddingWidth,
                    right: _paddingWidth,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _labelWidth,
                        child: Text('メモ'),
                      ),
                      SizedBox(
                        width: _paddingWidth * 2 + _iconWidth,
                      ),
                      Container(
                        width: _displayWidth -
                            (_labelWidth + _iconWidth * 2 + _paddingWidth * 5),
                        height: _textFormHeight,
                        child: TextFormField(
                          initialValue: '${model.note}',
                          onChanged: (text) {
                            model.changeNote(text);
                          },
                          minLines: 1,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            errorText: null,
                            contentPadding: EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              top: 2.0,
                              bottom: 2.0,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: greyColor,
                  height: 5,
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: _paddingWidth,
                    right: _paddingWidth,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _labelWidth,
                        child: model.currentTab == 0
                            ? Text('支出')
                            : model.currentTab == 1
                                ? Text('収入')
                                : SizedBox(),
                      ),
                      SizedBox(
                        width: _paddingWidth * 2 + _iconWidth,
                      ),
                      Container(
                        width: _displayWidth -
                            (_labelWidth + _iconWidth * 2 + _paddingWidth * 5),
                        height: model.showPriceError
                            ? _textFormHeight + 26.0
                            : _textFormHeight,
                        child: TextFormField(
                          initialValue: '${model.price}',
                          onChanged: (text) {
                            model.changePrice(text);
                          },
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              top: 2.0,
                              bottom: 2.0,
                            ),
                            errorText:
                                model.showPriceError ? '正しい数値を入力して下さい。' : null,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _paddingWidth,
                      ),
                      Container(
                        width: _iconWidth,
                        child: Text('円'),
                      ),
                    ],
                  ),
                ),
                model.currentTab == 0
                    ? const Divider(
                        color: greyColor,
                        height: 5,
                        thickness: 1,
                      )
                    : SizedBox(),
                model.currentTab == 0
                    ? Container(
                        height: _textFormHeight,
                        padding: EdgeInsets.only(
                          left: _paddingWidth,
                          right: _paddingWidth,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: _labelWidth,
                              child: Text('納得度'),
                            ),
                            SizedBox(
                              width: _paddingWidth * 2 + _iconWidth,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: _satisfactionLabelWidth,
                                    child: Text('低'),
                                  ),
                                  Container(
                                    width: _displayWidth -
                                        (_paddingWidth * 5 +
                                            _labelWidth +
                                            _iconWidth * 2 +
                                            _satisfactionLabelWidth * 2),
                                    height: _iconWidth,
                                    child: Slider(
                                      value: model.satisfaction.toDouble(),
                                      min: 1,
                                      max: 5,
                                      label: '${model.satisfaction}',
                                      divisions: 4,
                                      inactiveColor: Colors.grey,
                                      activeColor: Colors.orange,
                                      onChanged: (value) {
                                        model.changeSlider(value);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: _satisfactionLabelWidth,
                                    child: Text('高'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                const Divider(
                  color: greyColor,
                  height: 10,
                  thickness: 1,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: _paddingWidth,
                        right: _paddingWidth,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('カテゴリー'),
                          SizedBox(
                            height: 8.0,
                          ),
                          model.currentTab == 0
                              ? _expenseCategories(
                                  context, _displayWidth, _paddingWidth)
                              : _incomeCategories(
                                  context, _displayWidth, _paddingWidth),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: greyColor,
                  height: 20,
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    onPressed: model.isPriceValid
                        ? () async {
                            if (model.currentTab == 0) {
                              await model.updateExpense();
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('支出を上書きしました。'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CalendarPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (model.currentTab == 1) {
                              await model.updateIncome();
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('収入を上書きしました。'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CalendarPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              print('エラーが発生');
                              return;
                            }
                          }
                        : null,
                    child: model.currentTab == 0
                        ? Text(
                            '支出を上書きする',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : model.currentTab == 1
                            ? Text(
                                '収入を上書きする',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : SizedBox(),
                    color: Color(0xFFF39800),
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _expenseCategories(
      BuildContext context, double _displayWidth, double _paddingWidth) {
    final model = Provider.of<ExpenseUpdateModel>(context);
    var list = [];
    var loop = (model.expenseCategories.length / 3).ceil();
    var length = model.expenseCategories.length;
    for (var i = 0; i < loop; i++) {
      list.add(
        Container(
          padding: EdgeInsets.only(bottom: _paddingWidth),
          child: Row(
            children: [
              _categoryContainer(
                  context,
                  _displayWidth,
                  _paddingWidth,
                  model.expenseCategories[3 * i].id,
                  '${model.expenseCategories[3 * i].name}',
                  model.expenseCategories[3 * i].iconId,
                  model.expenseCategories[3 * i].colorId),
              SizedBox(
                width: _paddingWidth,
              ),
              (3 * i + 1 < length)
                  ? _categoryContainer(
                      context,
                      _displayWidth,
                      _paddingWidth,
                      model.expenseCategories[3 * i + 1].id,
                      model.expenseCategories[3 * i + 1].name,
                      model.expenseCategories[3 * i].iconId,
                      model.expenseCategories[3 * i].colorId)
                  : SizedBox(),
              SizedBox(
                width: _paddingWidth,
              ),
              (3 * i + 2 < length)
                  ? _categoryContainer(
                      context,
                      _displayWidth,
                      _paddingWidth,
                      model.expenseCategories[3 * i + 2].id,
                      model.expenseCategories[3 * i + 2].name,
                      model.expenseCategories[3 * i].iconId,
                      model.expenseCategories[3 * i].colorId)
                  : SizedBox(),
            ],
          ),
        ),
      );
    }
    return Column(children: list.cast<Widget>());
  }

  Widget _incomeCategories(
      BuildContext context, double _displayWidth, double _paddingWidth) {
    final model = Provider.of<ExpenseUpdateModel>(context);
    var list = [];
    var loop = (model.incomeCategories.length / 3).ceil();
    var length = model.incomeCategories.length;
    for (var i = 0; i < loop; i++) {
      list.add(
        Container(
          padding: EdgeInsets.only(bottom: _paddingWidth),
          child: Row(
            children: [
              _categoryContainer(
                  context,
                  _displayWidth,
                  _paddingWidth,
                  model.incomeCategories[3 * i].id,
                  '${model.incomeCategories[3 * i].name}',
                  model.incomeCategories[3 * i].iconId,
                  model.incomeCategories[3 * i].colorId),
              SizedBox(
                width: _paddingWidth,
              ),
              (3 * i + 1 < length)
                  ? _categoryContainer(
                      context,
                      _displayWidth,
                      _paddingWidth,
                      model.incomeCategories[3 * i + 1].id,
                      model.incomeCategories[3 * i + 1].name,
                      model.incomeCategories[3 * i].iconId,
                      model.incomeCategories[3 * i].colorId)
                  : SizedBox(),
              SizedBox(
                width: _paddingWidth,
              ),
              (3 * i + 2 < length)
                  ? _categoryContainer(
                      context,
                      _displayWidth,
                      _paddingWidth,
                      model.incomeCategories[3 * i + 2].id,
                      model.incomeCategories[3 * i + 2].name,
                      model.incomeCategories[3 * i].iconId,
                      model.incomeCategories[3 * i].colorId)
                  : SizedBox(),
            ],
          ),
        ),
      );
    }
    return Column(children: list.cast<Widget>());
  }

  Widget _categoryContainer(BuildContext context, double _displayWidth,
      double _paddingWidth, int id, String name, int iconId, int colorId) {
    final model = Provider.of<ExpenseUpdateModel>(context);
    return InkWell(
      onTap: () {
        model.tapCategory(id);
      },
      child: Container(
        padding: EdgeInsets.all(_paddingWidth),
        width: (_displayWidth - _paddingWidth * 4) / 3,
        child: Container(
          child: Column(
            children: [
              Text('id: $id'),
              SizedBox(
                height: 4.0,
              ),
              Icon(
                iconList[iconId],
                color: colorList[colorId],
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                '$name',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                id == model.expenseCategoryId ? Colors.orange[300] : greyColor,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
