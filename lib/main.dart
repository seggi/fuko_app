import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/provider/authentication.dart';
import 'package:fuko_app/provider/fk_providers.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:provider/provider.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await UserPreferences.init();
  FlutterNativeSplash.removeAfter(initialization);
  return runApp(
    MultiProvider(
      providers: FkProvider.multi(),
      child: const FukoApp(),
    ),
  );
}

void initialization(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 1));
}

class FukoApp extends StatelessWidget {
  const FukoApp({Key? key}) : super(key: key);
  static const title = 'Fuko';

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<AuthenticationData>.value(
        value: loginInfo,
        child: MaterialApp.router(
          title: 'Fuko',
          theme: ThemeData(
            primaryColor: fkDefaultColor,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: fkDefaultColor,
              secondary: const Color(0XFFF9F9F9),
            ),
          ),
          debugShowCheckedModeBanner: false,
          routeInformationParser: PagesGenerator.router.routeInformationParser,
          routerDelegate: PagesGenerator.router.routerDelegate,
        ),
      );
}
