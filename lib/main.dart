import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/provider/fk_providers.dart';
import 'package:provider/provider.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await UserPreferences.init();
  return runApp(
    MultiProvider(
      providers: FkProvider.multi(),
      child: const FukoApp(),
    ),
  );
}

class FukoApp extends StatelessWidget {
  const FukoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
          pages: PagesGenerator().getPage(context),
          onPopPage: (route, result) =>
              PagesGenerator.backTo(context, rt: route, res: result)),
    );
  }
}
