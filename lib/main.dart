import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/route_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuko_app/provider/authentication.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await UserPreferences.init();
  runApp(ChangeNotifierProvider(
    create: (_) => AuthenticationModel(),
    child: FukoApp(),
  ));
}

class FukoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<LoginInfo>.value(
        value: loginInfo,
        child: MaterialApp.router(
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
        ),
      );
  final loginInfo = LoginInfo();
  late final _router = GoRouter(
    routes: [...RouteGenerator.routesItem],
    redirect: (state) {
      final loggedIn = loginInfo.loggedIn;
      final loggingIn = state.subloc == '/login';
      if (!loggedIn) return loggingIn ? null : '/login';

      if (loggingIn) return '/';
      return null;
    },
    refreshListenable: loginInfo,
  );
}
