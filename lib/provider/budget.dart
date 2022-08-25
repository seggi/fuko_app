import 'package:flutter/material.dart';

class SelectFromDataList extends ChangeNotifier {
  Map _items = {};
  Map _periods = {};

  Map get getNewItem => _items;
  Map get getPeriod => _periods;

  void add(Map item) {
    _items = item;
    notifyListeners();
  }

  void addPeriod(Map item) {
    _periods = item;
    notifyListeners();
  }
}
