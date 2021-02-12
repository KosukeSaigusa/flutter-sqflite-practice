import 'package:flutter/material.dart';

const appBarHeight = 45.0;
const dateCellHeight = 61.0;

const daysOfWeek = ['月', '火', '水', '木', '金', '土', '日'];

const smTextStyle = TextStyle(
  fontSize: 12.0,
);

/// length //////////////////////////////////////
// 汎用
const marginSm = 4.0;
const marginMd = 8.0;

// カレンダーページ

// 固定費ページ
const monthlyFeeTextWidth = 120.0;

// カテゴリーページ
const iconWidth = 24.0;
const rightAlignedTextWidth = 120.0;
const percentageBarHeight = 17.2;

// 支出追加・編集ページ

// カテゴリー追加・編集ページ

/////////////////////////////////////////////////

enum WriteOptions {
  add,
  update,
}

// Colors.amber[100]
const selectedColor = Color(0xFFFFECB3);

// Colors.grey[300]
// const greyColor = Color(0xFFE0E0E0);

// Colors.grey[200]
const greyColor = Color(0xFFEEEEEE);

/// Icons
const iconList = [
  Icons.shopping_cart,
  Icons.local_grocery_store_outlined,
  Icons.local_restaurant,
  Icons.local_dining,
  Icons.food_bank_outlined,
  Icons.fastfood,
  Icons.local_pizza_outlined,
  Icons.local_bar_rounded,
  Icons.local_cafe_outlined,
  Icons.local_convenience_store_outlined,
  Icons.local_airport,
  Icons.commute,
  Icons.train,
  Icons.local_taxi_sharp,
  Icons.local_hospital,
  Icons.local_laundry_service_outlined,
  Icons.local_mall,
  Icons.local_offer_outlined,
  Icons.sports_bar_outlined,
  Icons.wine_bar,
  Icons.phone_android,
  Icons.network_wifi,
  Icons.wb_incandescent_sharp,
  Icons.warning_amber_rounded,
];

/// Colors
const colorList = [
  Colors.black,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.redAccent,
  Colors.pinkAccent,
  Colors.purpleAccent,
  Colors.deepPurpleAccent,
  Colors.indigoAccent,
  Colors.blueAccent,
  Colors.lightBlueAccent,
  Colors.cyanAccent,
  Colors.tealAccent,
  Colors.greenAccent,
  Colors.lightGreenAccent,
  Colors.limeAccent,
  Colors.yellowAccent,
  Colors.amberAccent,
  Colors.orangeAccent,
  Colors.deepOrangeAccent,
];
