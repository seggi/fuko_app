import 'package:flutter/material.dart';

class SelectFromDataList extends ChangeNotifier {
  Map _items = {};
  Map _periods = {};
  String _requestNumber = '';
  String _id = '';
  double _computeTotalAmount = 0.0;
  double _amountOne = 0.0;
  double _amountTwo = 0.0;
  final List _itemList = [];

  Map get getNewItem => _items;
  Map get getPeriod => _periods;
  String get getId => _id;
  List get getNewItemList => _itemList;
  String get getRequestNumber => _requestNumber;
  double get getTotalComputedAmount => _computeTotalAmount;
  double get getAmountOne => _amountOne;
  double get getAmountTwo => _amountTwo;

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

  void amountOne(double amount) {
    _amountOne = amount;
    notifyListeners();
  }

  void amountTwo(double amount) {
    _amountTwo = amount;
    notifyListeners();
  }

  void manageTotalAmount() {
    _computeTotalAmount = _amountOne + _amountTwo;
    notifyListeners();
  }

  void removeTotalAmount() {
    _amountTwo = 0.0;
    _amountOne = 0.0;
    print("::::");
    notifyListeners();
  }
}
