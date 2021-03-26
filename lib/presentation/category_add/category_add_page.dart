import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/appbar.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/common/keyboard_done_button.dart';
import 'package:flutter_sqflite_practice/domain/expense_category.dart';
import 'package:flutter_sqflite_practice/domain/income_category.dart';
import 'package:flutter_sqflite_practice/presentation/category_add/category_add_model.dart';
import 'package:flutter_sqflite_practice/presentation/top/top_page.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:provider/provider.dart';

class CategoryAddPage extends StatelessWidget {
  CategoryAddPage({
    @required this.option,
    this.expenseCategory,
    this.incomeCategory,
  });

  final WriteOptions option;
  final ExpenseCategory expenseCategory;
  final IncomeCategory incomeCategory;

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeBudget = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        _keyboardActionItems(_focusNodeName),
        _keyboardActionItems(_focusNodeBudget),
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
    final _displayWidth = MediaQuery.of(context).size.width;
    const _labelWidth = 60.0;
    final _displayHeight = MediaQuery.of(context).size.height;
    const _paddingWidth = 8.0;
    const _iconWidth = 16.0;
    const _textFormHeight = 36.0;
    return Scaffold(
      appBar: customAppBar,
      body: ChangeNotifierProvider<CategoryAddModel>(
        create: (_) =>
            CategoryAddModel(option, expenseCategory, incomeCategory),
        child: Consumer<CategoryAddModel>(
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
                                      await model.deleteExpenseCategory();
                                      await _showDeletedDialog(context);
                                    }
                                    if (model.currentTab == 1) {
                                      await model.deleteIncomeCategory();
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
                    height: _paddingWidth,
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
                          child: Text('名前'),
                        ),
                        SizedBox(
                          width: _paddingWidth * 2 + _iconWidth,
                        ),
                        Container(
                          width: _displayWidth -
                              (_labelWidth +
                                  _iconWidth * 2 +
                                  _paddingWidth * 5),
                          height: model.showNameError
                              ? _textFormHeight + 26.0
                              : _textFormHeight,
                          child: TextFormField(
                            focusNode: _focusNodeName,
                            initialValue: '${model.name}',
                            onChanged: (text) {
                              model.changeName(text);
                            },
                            minLines: 1,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            decoration: InputDecoration(
                              errorText:
                                  model.showNameError ? '正しい名前を入力して下さい。' : null,
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
                  model.currentTab == 0
                      ? const Divider(
                          color: greyColor,
                          height: 5,
                          thickness: 1,
                        )
                      : SizedBox(),
                  model.currentTab == 0
                      ? Container(
                          padding: EdgeInsets.only(
                            left: _paddingWidth,
                            right: _paddingWidth,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: _labelWidth,
                                child: Text('予算'),
                              ),
                              SizedBox(
                                width: _paddingWidth * 2 + _iconWidth,
                              ),
                              Container(
                                width: _displayWidth -
                                    (_labelWidth +
                                        _iconWidth * 2 +
                                        _paddingWidth * 5),
                                height: model.showBudgetError
                                    ? _textFormHeight + 26.0
                                    : _textFormHeight,
                                child: TextFormField(
                                  focusNode: _focusNodeBudget,
                                  keyboardType: TextInputType.number,
                                  initialValue: model.budget == null
                                      ? ''
                                      : '${model.budget}',
                                  onChanged: (text) {
                                    model.changeBudget(text);
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
                                    errorText: model.showBudgetError
                                        ? '正しい数値を入力して下さい。'
                                        : null,
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
                            Text('アイコン'),
                            SizedBox(
                              height: 8.0,
                            ),
                            _iconPalette(context, _displayWidth),
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
                            Text('カラー'),
                            SizedBox(
                              height: 8.0,
                            ),
                            _colorPalette(context, _displayWidth),
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
                      left: marginMd,
                      right: marginMd,
                    ),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      child: option == WriteOptions.add
                          ? Text(
                              'カテゴリーを登録する',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              'カテゴリーを更新する',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      // color: Color(0xFFF39800),
                      // textColor: Colors.white,
                      onPressed: option == WriteOptions.add
                          ? model.currentTab == 0
                              ? (model.isNameValid && model.isBudgetValid)
                                  ? () async {
                                      await model.addExpenseCategory();
                                      await _showDialog(context, option);
                                    }
                                  : null
                              : model.currentTab == 1
                                  ? model.isNameValid
                                      ? () async {
                                          await model.addIncomeCategory();
                                          await _showDialog(context, option);
                                        }
                                      : null
                                  : null
                          : option == WriteOptions.update
                              ? model.currentTab == 0
                                  ? (model.isNameValid && model.isBudgetValid)
                                      ? () async {
                                          await model.updateExpenseCategory();
                                          await _showDialog(context, option);
                                        }
                                      : null
                                  : model.currentTab == 1
                                      ? model.isNameValid
                                          ? () async {
                                              await model
                                                  .updateIncomeCategory();
                                              await _showDialog(
                                                  context, option);
                                            }
                                          : null
                                      : null
                              : null,
                    ),
                  ),
                  SizedBox(
                    height: _displayHeight * 0.10,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _iconPalette(BuildContext context, double _displayWidth) {
    var length = iconList.length;
    var numColumns = 5;
    var loop = (length / numColumns).ceil();
    var listRows = [];
    var elements = [];
    var count = 0;
    var _paddingWidth = 8.0;
    var _containerWidth =
        (_displayWidth - _paddingWidth * (numColumns + 1)) / numColumns;
    for (var i = 0; i < loop; i++) {
      elements = [];
      for (var j = 0; j < numColumns; j++) {
        if (count < length) {
          elements.add(
            Row(
              children: [
                Column(
                  children: [
                    _iconContainer(
                        context, count, _containerWidth, _paddingWidth),
                    SizedBox(
                      height: _paddingWidth,
                    ),
                  ],
                ),
                (count % numColumns != numColumns - 1)
                    ? SizedBox(
                        width: _paddingWidth,
                      )
                    : SizedBox(),
              ],
            ),
          );
          count++;
        }
      }
      listRows.add(
        Row(
          children: elements.cast<Widget>(),
        ),
      );
    }
    return Column(
      children: listRows.cast<Widget>(),
    );
  }

  Widget _iconContainer(BuildContext context, int count, double _containerWidth,
      double _paddingWidth) {
    final model = Provider.of<CategoryAddModel>(context);
    return InkWell(
      onTap: () {
        model.tapIcon(count);
      },
      child: Container(
        padding: EdgeInsets.all(_paddingWidth),
        width: _containerWidth,
        child: Icon(
          iconList[count],
          color: model.iconId == count ? model.iconColor : greyColor,
          // color: Colors.black,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: model.iconId == count ? Colors.grey : greyColor,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Widget _colorPalette(BuildContext context, double _displayWidth) {
    var length = colorList.length;
    var numColumns = 5;
    var loop = (length / numColumns).ceil();
    var listRows = [];
    var elements = [];
    var count = 0;
    var _paddingWidth = 8.0;
    var _containerWidth =
        (_displayWidth - _paddingWidth * (numColumns + 1)) / numColumns;
    for (var i = 0; i < loop; i++) {
      elements = [];
      for (var j = 0; j < numColumns; j++) {
        if (count < length) {
          elements.add(
            Row(
              children: [
                Column(
                  children: [
                    _colorContainer(
                        context, count, _containerWidth, _paddingWidth),
                    SizedBox(
                      height: _paddingWidth,
                    ),
                  ],
                ),
                (count % numColumns != numColumns - 1)
                    ? SizedBox(
                        width: _paddingWidth,
                      )
                    : SizedBox(),
              ],
            ),
          );
          count++;
        }
      }
      listRows.add(
        Row(
          children: elements.cast<Widget>(),
        ),
      );
    }
    return Column(
      children: listRows.cast<Widget>(),
    );
  }

  Widget _colorContainer(BuildContext context, int count,
      double _containerWidth, double _paddingWidth) {
    final model = Provider.of<CategoryAddModel>(context);
    return InkWell(
      onTap: () {
        model.tapColor(count);
      },
      child: Container(
        width: _containerWidth,
        height: 30,
        decoration: BoxDecoration(
          color: colorList[count],
          border: Border.all(
            color: model.colorId == count ? Colors.grey : greyColor,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeletedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text('カテゴリーを削除しました。'),
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

  Future<void> _showDialog(BuildContext context, WriteOptions option) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text(option == WriteOptions.add
              ? 'カテゴリーを登録しました。'
              : option == WriteOptions.update
                  ? 'カテゴリーを更新しました。'
                  : ''),
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
