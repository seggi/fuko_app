import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/route_generator.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load();
  runApp(FukoApp());
}

class FukoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuko',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: fkDefaultColor,
          secondary: const Color(0XFFF9F9F9),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
