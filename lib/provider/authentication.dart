import 'package:flutter/material.dart';

class AuthenticationData extends ChangeNotifier {
  var _userToken = '';
  final List _items = [];

  String get userToken => _userToken;
  bool get loggedIn => _userToken.isNotEmpty;
  List get getUserData => _items;

  void login(String userToken) {
    _userToken = userToken;
    notifyListeners();
  }

  void logout() {
    _userToken = '';
    notifyListeners();
  }

  void add(Map item) {
    _items.add(item);
    notifyListeners();
  }
}
