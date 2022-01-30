import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fuko_app/screens/auth/login.dart';
import 'package:fuko_app/widgets/shared/style.dart';

void main() {
  runApp(FukoApp());
}

class FukoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuko',
      theme: ThemeData(
        // textTheme: GoogleFonts.robotoTextTheme(),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: fkDefaultColor,
          secondary: const Color(0XFFF9F9F9),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
