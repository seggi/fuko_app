import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/route_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await UserPreferences.init();
  runApp(FukoApp());
}

class FukoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Fuko();
  }
}

class Fuko extends StatefulWidget {
  const Fuko({Key? key}) : super(key: key);

  @override
  _FukoState createState() => _FukoState();
}

class _FukoState extends State<Fuko> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserPreferences.getToken(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null) {
                return intialStartApp(path: "/");
              } else {
                UserPreferences.removeToken();
              }
              return intialStartApp(path: "/home");
          }
        });
  }
}

Widget intialStartApp({path}) {
  return MaterialApp(
    title: 'Fuko',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: fkDefaultColor,
        secondary: const Color(0XFFF9F9F9),
      ),
    ),
    debugShowCheckedModeBanner: false,
    initialRoute: path,
    onGenerateRoute: RouteGenerator.generateRoute,
  );
}
