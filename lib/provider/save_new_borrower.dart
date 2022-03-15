import 'package:flutter/material.dart';

class SaveNewBorrower extends ChangeNotifier {
  final List _items = [];

  List get getUserData => _items;

  void add(Map item) {
    _items.add(item);
    notifyListeners();
  }
}
