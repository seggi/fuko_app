import 'package:flutter/material.dart';

class SelectFromDataList extends ChangeNotifier {
  Map _items = {};

  Map get getNewItem => _items;

  void add(Map item) {
    _items = item;
    notifyListeners();
  }
}
