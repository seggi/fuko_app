import 'package:flutter/material.dart';

class SelectFromDataList extends ChangeNotifier {
  Map _items = {};
  Map _periods = {};
  String _id = '';
  final List _itemList = [
    {"full_name": "seggi", "amount": "1000"}
  ];

  Map get getNewItem => _items;
  Map get getPeriod => _periods;
  String get getId => _id;
  List get getNewItemList => _itemList;

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

  void remove(Map itemData) {
    _itemList.removeWhere((item) => item['full_name'] == itemData["full_name"]);
    notifyListeners();
  }

  void addItem(Map item) {
    _itemList.add(item);
    notifyListeners();
  }
}
