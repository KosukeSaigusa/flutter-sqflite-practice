import 'package:flutter/material.dart';

class TopModel extends ChangeNotifier {
  TopModel() {
    currentIndex = 0;
  }

  int currentIndex;

  void onTabTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
