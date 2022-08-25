import 'package:flutter/material.dart';

class SelectFromDataList extends ChangeNotifier {
  Map _items = {};
  Map _periods = {};
  String _id = '';

  Map get getNewItem => _items;
  Map get getPeriod => _periods;
  String get getId => _id;

  void add(Map item) {
    _items = item;
    notifyListeners();
  }

  void addPeriod(Map item) {
    _periods = item;
    notifyListeners();
  }

  void saveId(String id) {
    _id = id;
    notifyListeners();
  }
}
