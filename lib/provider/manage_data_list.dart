import 'package:flutter/material.dart';

class SelectFromDataList extends ChangeNotifier {
  Map _items = {};
  Map _periods = {};
  String _requestNumber = '';
  String _id = '';
  final List _itemList = [];

  Map get getNewItem => _items;
  Map get getPeriod => _periods;
  String get getId => _id;
  List get getNewItemList => _itemList;
  String get getRequestNumber => _requestNumber;

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

  void remove() {
    _itemList.clear();
    notifyListeners();
  }

  void removeParticipator(Map itemData) {
    _itemList.removeWhere((item) => item['id'] == itemData["id"]);
    notifyListeners();
  }

  void addItem(Map item) {
    _itemList.add(item);
    notifyListeners();
  }

  void saveRequestNumber(String requestNumber) {
    _requestNumber = requestNumber;
    notifyListeners();
  }

  void removeEnvelope() {
    _items.clear();
    notifyListeners();
  }
}
