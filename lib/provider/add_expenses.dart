import 'package:flutter/material.dart';

class AddExpenses extends ChangeNotifier {
  var _screenTitle = '';
  String _currencyId = '';
  String _defaultCurrencyId = '';
  String _monthNumber = '';
  final List _items = [];
  final List _totalAmountList = [];

  List get getNewItem => _items;
  String get currencyId => _currencyId;
  String get monthNumber => _monthNumber;
  String get defaultCurrencyId => _defaultCurrencyId;
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

  void addCurrencyId(String currencyId) {
    _currencyId = currencyId;
    notifyListeners();
  }

  void addDefaultCurryId(String defaultCurryId) {
    _defaultCurrencyId = defaultCurryId;
    notifyListeners();
  }

  void addSelectedMonth(String monthNumber) {
    _monthNumber = monthNumber;
    notifyListeners();
  }
}
