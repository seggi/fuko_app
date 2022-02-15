import 'package:flutter/material.dart';
import 'package:fuko_app/screens/screen_list.dart';
import 'package:go_router/go_router.dart';

class LoginInfo extends ChangeNotifier {
  var _userName = '';
  String get userName => _userName;
  bool get loggedIn => _userName.isNotEmpty;

  void login(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void logout() {
    _userName = '';
    notifyListeners();
  }
}

class RouteGenerator {
  static final routesItem = [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => HomePage(data: state.params),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
        name: "register",
        path: '/register',
        builder: (context, state) => const LoginPage()),
    GoRoute(
        name: "complete-profile",
        path: '/complete-profile',
        builder: (context, state) => CompleteProfile(
              data: state.params,
            )),
  ];
}
