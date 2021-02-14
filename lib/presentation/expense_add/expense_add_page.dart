import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/appbar.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/common/keyboard_done_button.dart';
import 'package:flutter_sqflite_practice/common/weekday.dart';
import 'package:flutter_sqflite_practice/domain/expense.dart';
import 'package:flutter_sqflite_practice/domain/income.dart';
import 'package:flutter_sqflite_practice/presentation/expense_add/expense_add_model.dart';
import 'package:flutter_sqflite_practice/presentation/top/top_page.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

class ExpenseAddPage extends StatelessWidget {
  ExpenseAddPage({
    @required this.option,
    this.expense,
    this.income,
    this.year,
    this.month,
    this.date,
  });

  final WriteOptions option;
  final Expense expense;
  final Income income;
  final int year;
  final int month;
  final int date;

  final FocusNode _focusNodeNote = FocusNode();
  final FocusNode _focusNodePrice = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        _keyboardActionItems(_focusNodeNote),
        _keyboardActionItems(_focusNodePrice),
      ],
    );
  }

  KeyboardActionsItem _keyboardActionItems(_focusNode) {
    return KeyboardActionsItem(
      focusNode: _focusNode as FocusNode,
      toolbarButtons: [
        /// 「完了」ボタン
        (node) {
          return customDoneButton(_focusNode as FocusNode);
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar,
      body: ChangeNotifierProvider<ExpenseAddModel>(
        create: (_) =>
            ExpenseAddModel(option, expense, income, year, month, date),
        child: Consumer<ExpenseAddModel>(
          builder: (context, model, child) {
            return KeyboardActions(
              disableScroll: true, // フォームにフォーカス時にフォームをスクロールしない
              config: _buildConfig(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        option == WriteOptions.add
                            ? Container(
                                padding: EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                              )
                            : Container(
                                padding: EdgeInsets.all(4.0),
                                child: Container(
                                  width: 75.0,
                                  child: Center(
                                    child: Text(
                                      model.currentTab == 0
                                          ? '支出'
                                          : model.currentTab == 1
                                              ? '収入'
                                              : '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
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
                          child: option == WriteOptions.update
                              ? IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    if (model.currentTab == 0) {
                                      await model.deleteExpense(expense);
                                      await _showDeletedDialog(context);
                                    }
                                    if (model.currentTab == 1) {
                                      await model.deleteIncome(income);
                                      await _showDeletedDialog(context);
                                    }
                                  },
                                )
                              : SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: marginMd,
                  ),
                  Container(
                    height: textFormHeight,
                    padding: EdgeInsets.only(
                      left: marginMd,
                      right: marginMd,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: inputItemLabelWidth,
                          child: Text('日付'),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          height: backForwardButtonWidth,
                          width: backForwardButtonWidth,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: backForwardButtonWidth,
                            ),
                            onPressed: () {
                              model.showPreviousDay();
                            },
                          ),
                        ),
                        SizedBox(
                          width: marginMd,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (inputItemLabelWidth +
                                  backForwardButtonWidth * 2 +
                                  marginMd * 5),
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
                          width: marginMd,
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
                      left: marginMd,
                      right: marginMd,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: inputItemLabelWidth,
                          child: Text('メモ'),
                        ),
                        SizedBox(
                          width: marginMd * 2 + backForwardButtonWidth,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (inputItemLabelWidth +
                                  backForwardButtonWidth * 2 +
                                  marginMd * 5),
                          height: textFormHeight,
                          child: TextFormField(
                            focusNode: _focusNodeNote,
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
                      left: marginMd,
                      right: marginMd,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: inputItemLabelWidth,
                          child: model.currentTab == 0
                              ? Text('支出')
                              : model.currentTab == 1
                                  ? Text('収入')
                                  : SizedBox(),
                        ),
                        SizedBox(
                          width: marginMd * 2 + backForwardButtonWidth,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (inputItemLabelWidth +
                                  backForwardButtonWidth * 2 +
                                  marginMd * 5),
                          height: model.showPriceError
                              ? textFormHeight + 26.0
                              : textFormHeight,
                          child: TextFormField(
                            focusNode: _focusNodePrice,
                            keyboardType: TextInputType.number,
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
                              errorText: model.showPriceError
                                  ? '正しい数値を入力して下さい。'
                                  : null,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: marginMd,
                        ),
                        Container(
                          width: backForwardButtonWidth,
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
                          height: textFormHeight,
                          padding: EdgeInsets.only(
                            left: marginMd,
                            right: marginMd,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: inputItemLabelWidth,
                                child: Text('納得度'),
                              ),
                              SizedBox(
                                width: marginMd * 2 + backForwardButtonWidth,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: satisfactionLabelWidth,
                                      child: Text('低'),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          (marginMd * 5 +
                                              inputItemLabelWidth +
                                              backForwardButtonWidth * 2 +
                                              satisfactionLabelWidth * 2),
                                      height: backForwardButtonWidth,
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
                                      width: satisfactionLabelWidth,
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
                          left: marginMd,
                          right: marginMd,
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
                                ? _expenseCategories(context)
                                : _incomeCategories(context),
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
                                if (option == WriteOptions.add) {
                                  await model.addExpense();
                                  await _showDoneDialog(
                                      context, model.currentTab);
                                }
                                if (option == WriteOptions.update) {
                                  await model.updateExpense(model.expense);
                                  await _showDoneDialog(
                                      context, model.currentTab);
                                }
                              } else if (model.currentTab == 1) {
                                if (option == WriteOptions.add) {
                                  await model.addIncome();
                                  await _showDoneDialog(
                                      context, model.currentTab);
                                }
                                if (option == WriteOptions.update) {
                                  await model.updateIncome(model.income);
                                  await _showDoneDialog(
                                      context, model.currentTab);
                                }
                              } else {
                                print('エラーが発生');
                                return;
                              }
                            }
                          : null,
                      child: Text(
                        model.currentTab == 0
                            ? option == WriteOptions.add
                                ? '支出を登録する'
                                : option == WriteOptions.update
                                    ? '支出を更新する'
                                    : ''
                            : model.currentTab == 1
                                ? option == WriteOptions.add
                                    ? '収入を登録する'
                                    : option == WriteOptions.update
                                        ? '収入を更新する'
                                        : ''
                                : '',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Color(0xFFF39800),
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
                  // RaisedButton(
                  //   onPressed: () async {
                  //     await model.addExpenseCategory();
                  //   },
                  //   child: Text('支出カテゴリーを追加'),
                  //   color: Color(0xFFF39800),
                  //   textColor: Colors.white,
                  // ),
                  // RaisedButton(
                  //   onPressed: () async {
                  //     await model.addIncomeCategory();
                  //   },
                  //   child: Text('収入カテゴリーを追加'),
                  //   color: Color(0xFFF39800),
                  //   textColor: Colors.white,
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _expenseCategories(BuildContext context) {
    final model = Provider.of<ExpenseAddModel>(context);
    var list = [];
    var loop = (model.expenseCategories.length / 3).ceil();
    var length = model.expenseCategories.length;
    for (var i = 0; i < loop; i++) {
      list.add(
        Container(
          padding: EdgeInsets.only(bottom: marginMd),
          child: Row(
            children: [
              _categoryContainer(
                  context,
                  model.expenseCategories[3 * i].id,
                  '${model.expenseCategories[3 * i].name}',
                  model.expenseCategories[3 * i].iconId,
                  model.expenseCategories[3 * i].colorId),
              SizedBox(
                width: marginMd,
              ),
              (3 * i + 1 < length)
                  ? _categoryContainer(
                      context,
                      model.expenseCategories[3 * i + 1].id,
                      model.expenseCategories[3 * i + 1].name,
                      model.expenseCategories[3 * i + 1].iconId,
                      model.expenseCategories[3 * i + 1].colorId)
                  : SizedBox(),
              SizedBox(
                width: marginMd,
              ),
              (3 * i + 2 < length)
                  ? _categoryContainer(
                      context,
                      model.expenseCategories[3 * i + 2].id,
                      model.expenseCategories[3 * i + 2].name,
                      model.expenseCategories[3 * i + 2].iconId,
                      model.expenseCategories[3 * i + 2].colorId)
                  : SizedBox(),
            ],
          ),
        ),
      );
    }
    return Column(children: list.cast<Widget>());
  }

  Widget _incomeCategories(BuildContext context) {
    final model = Provider.of<ExpenseAddModel>(context);
    var list = [];
    var loop = (model.incomeCategories.length / 3).ceil();
    var length = model.incomeCategories.length;
    for (var i = 0; i < loop; i++) {
      list.add(
        Container(
          padding: EdgeInsets.only(bottom: marginMd),
          child: Row(
            children: [
              _categoryContainer(
                  context,
                  model.incomeCategories[3 * i].id,
                  '${model.incomeCategories[3 * i].name}',
                  model.incomeCategories[3 * i].iconId,
                  model.incomeCategories[3 * i].colorId),
              SizedBox(
                width: marginMd,
              ),
              (3 * i + 1 < length)
                  ? _categoryContainer(
                      context,
                      model.incomeCategories[3 * i + 1].id,
                      model.incomeCategories[3 * i + 1].name,
                      model.incomeCategories[3 * i + 1].iconId,
                      model.incomeCategories[3 * i + 1].colorId)
                  : SizedBox(),
              SizedBox(
                width: marginMd,
              ),
              (3 * i + 2 < length)
                  ? _categoryContainer(
                      context,
                      model.incomeCategories[3 * i + 2].id,
                      model.incomeCategories[3 * i + 2].name,
                      model.incomeCategories[3 * i + 2].iconId,
                      model.incomeCategories[3 * i + 2].colorId)
                  : SizedBox(),
            ],
          ),
        ),
      );
    }
    return Column(children: list.cast<Widget>());
  }

  Widget _categoryContainer(
      BuildContext context, int id, String name, int iconId, int colorId) {
    final model = Provider.of<ExpenseAddModel>(context);
    return InkWell(
      onTap: () {
        model.tapCategory(id);
      },
      child: Container(
        padding: EdgeInsets.all(marginMd),
        width: (MediaQuery.of(context).size.width - marginMd * 4) / 3,
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
            color: model.currentTab == 0
                ? id == model.expenseCategoryId
                    ? Colors.orange[300]
                    : greyColor
                : model.currentTab == 1
                    ? id == model.incomeCategoryId
                        ? Colors.orange[300]
                        : greyColor
                    : greyColor,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Future<void> _showDoneDialog(BuildContext context, int currentTab) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text(option == WriteOptions.add
              ? currentTab == 0
                  ? '支出を登録しました。'
                  : currentTab == 1
                      ? '収入を登録しました。'
                      : ''
              : option == WriteOptions.update
                  ? currentTab == 0
                      ? '支出を更新しました。'
                      : currentTab == 1
                          ? '収入を更新しました。'
                          : ''
                  : ''),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeletedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text('削除しました。'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
