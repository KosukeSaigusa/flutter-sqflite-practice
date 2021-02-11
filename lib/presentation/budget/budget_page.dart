import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/appbar.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/presentation/budget/budget_model.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _displayWidth = MediaQuery.of(context).size.width;
    final _displayHeight = MediaQuery.of(context).size.height;
    const _paddingWidth = 8.0;
    const _rowMargin = 4.0;
    const _rightTextAreaWidth = 120.0;
    final _percentageBarWidth =
        _displayWidth - (_paddingWidth * 4 + _rightTextAreaWidth);
    const _percentageBarHeight = 17.2;
    return Scaffold(
      appBar: customAppBar,
      body: ChangeNotifierProvider<BudgetModel>(
        create: (_) => BudgetModel(),
        child: Consumer<BudgetModel>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < 10; i++)
                    Card(
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
                                Icon(Icons.fastfood),
                                SizedBox(
                                  width: _paddingWidth,
                                ),
                                Text('食品・栄養'),
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  width: _rightTextAreaWidth,
                                  child: Text(
                                    '予算：30,000 円',
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
                                  '2021年2月',
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  width: _rightTextAreaWidth,
                                  child: Text(
                                    '実績：2,000 円',
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.blue,
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
                                        color: Colors.blue,
                                        width: _percentageBarWidth * 0.667,
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
                                    '66.7 %',
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.blue,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
