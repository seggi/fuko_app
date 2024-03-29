import 'package:flutter/material.dart';

class RecordAmount extends ChangeNotifier {
  var _screenTitle = '';
  String _borrowerId = '';
  final List _items = [];
  final List _totalAmountList = [];

  List get getNewItem => _items;
  String get borrowerId => _borrowerId;
  String get screenTitle => _screenTitle;
  double get getTotalAmount {
    // Compute total amount in the list
    var sum = _totalAmountList.isNotEmpty
        ? _totalAmountList.reduce((value, element) =>
            double.parse(value.toString()) + double.parse(element.toString()))
        : 0.0;
    return sum;
  }

  void addAmount(double item) {
    _totalAmountList.add(item);
    notifyListeners();
  }

  void add(Map item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Map itemData) {
    _items
        .removeWhere((item) => item['description'] == itemData["description"]);

    _totalAmountList.remove(itemData['amount']);
    notifyListeners();
  }

  void removeFromList() {
    _items.clear();
    _totalAmountList.clear();
    notifyListeners();
  }

  void addScreenTitle(String screenTitle) {
    _screenTitle = screenTitle;
    notifyListeners();
  }

  void saveBorrowerId(String borrowerId) {
    _borrowerId = borrowerId;
    notifyListeners();
  }
}
