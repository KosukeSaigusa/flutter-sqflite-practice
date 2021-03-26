import 'package:flutter/material.dart';
import 'package:flutter_sqflite_practice/common/appbar.dart';
import 'package:flutter_sqflite_practice/common/constants.dart';
import 'package:flutter_sqflite_practice/presentation/fixed_fee/fixed_fee_model.dart';
import 'package:provider/provider.dart';

class FixedFeePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar,
      body: ChangeNotifierProvider<FixedFeeModel>(
        create: (_) => FixedFeeModel(),
        child: Consumer<FixedFeeModel>(
          builder: (context, model, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: greyColor,
                  padding: EdgeInsets.all(marginMd),
                  child: Row(
                    children: [
                      Text(
                        '固定費一覧（合計：106,663 円）',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _fixedFeeCards(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _displayWidth - marginSm * 2,
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  padding: EdgeInsets.all(marginMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '2021年2月の固定費：未登録',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: marginMd,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          // color: Color(0xFFF39800),
                          // textColor: Colors.white,
                          child: Text('上記の固定費を登録する'),
                          onPressed: () {
                            print('固定費を登録！！');
                          },
                        ),
                      ),
                      SizedBox(
                        height: marginMd,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _fixedFeeCards(BuildContext context) {
    final model = Provider.of<FixedFeeModel>(context);
    var list = [];
    for (var i = 0; i < model.fixedFees.length; i++) {
      list.add(
        InkWell(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(marginMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width -
                            (monthlyFeeTextWidth + marginSm * 2 + marginMd * 2),
                        child: Text(
                          '${model.fixedFees[i].name}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: monthlyFeeTextWidth,
                        child: Text(
                          // ToDo: 月額・年額の割り算の扱い
                          '月額：${(model.fixedFees[i].price / model.fixedFees[i].paymentCycleId).ceil()} 円'
                              .replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (m) => '${m[1]},'),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  model.fixedFees[i].paymentCycleId != 1
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  (marginSm * 2 + marginMd * 2),
                              child: Text(
                                '${model.fixedFees[i].paymentCycleId}ヶ月毎 ${model.fixedFees[i].price} 円'
                                    .replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (m) => '${m[1]},'),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
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
