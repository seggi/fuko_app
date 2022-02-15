import 'package:fuko_app/screens/screen_list.dart';
import 'package:go_router/go_router.dart';

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
  ];

  static redirectRoute(state, loginInfo) {
    final loggedIn = loginInfo.loggedIn;
    final loggingIn = state.subloc == '/login';
    if (!loggedIn) return loggingIn ? null : '/login';

    if (loggingIn) return '/';
    return null;
  }
}
