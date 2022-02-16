import 'package:flutter/material.dart';

class NavigationPath extends ChangeNotifier {
  String _screenPath = '/';

  String get screenPath => _screenPath;

  void changeScreen(String screenPath) {
    _screenPath = screenPath;
    notifyListeners();
  }
}
