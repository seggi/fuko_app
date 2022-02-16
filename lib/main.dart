import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/provider/fk_providers.dart';
import 'package:provider/provider.dart';

Future main() async {
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
