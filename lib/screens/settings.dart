import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/profile.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:intl/intl.dart';

class SettingScreen extends StatefulWidget {
  final String? data;
  const SettingScreen({Key? key, this.data}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late Future<List<ProfileData>>? retrieveProfile;

  @override
  void initState() {
    retrieveProfile = fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Align(
            alignment: Alignment.centerLeft, child: Text("Settings")),
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
