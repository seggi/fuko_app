import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/profile.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
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
  late bool isEditDefaultCurrency = false;
  late bool isEditGroupDefaultCurrency = false;
  late TextEditingController changeDefaultCurrencyController =
      TextEditingController();

  @override
  void initState() {
    retrieveProfile = fetchProfile();
    isEditDefaultCurrency = false;
    isEditGroupDefaultCurrency = false;
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Currency",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                verticalSpaceMedium,
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Default currency",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      verticalSpaceSmall,
                      isEditDefaultCurrency == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("USD",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                IconButton(
                                    onPressed: () => setState(() {
                                          isEditDefaultCurrency = true;
                                        }),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: fkDefaultColor,
                                    ))
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  color: fkBlueText,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 120,
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text("USD",
                                            style: TextStyle(
                                                color: fkWhiteText,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: fkDefaultColor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CurrencyButtonSheet(),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () => setState(() {
                                          isEditDefaultCurrency = false;
                                        }),
                                    icon: const Icon(
                                      Icons.check,
                                      color: fkDefaultColor,
                                    ))
                              ],
                            )
                    ],
                  ),
                ),
                verticalSpaceSmall,
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Group Default currency",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      verticalSpaceRegular,
                      isEditGroupDefaultCurrency == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("USD",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                IconButton(
                                    onPressed: () => setState(() {
                                          isEditGroupDefaultCurrency = true;
                                        }),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: fkDefaultColor,
                                    ))
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  color: fkBlueText,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 120,
                                        padding: const EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: const Text("USD",
                                            style: TextStyle(
                                                color: fkWhiteText,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: fkDefaultColor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CurrencyButtonSheet(),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () => setState(() {
                                          isEditGroupDefaultCurrency = false;
                                        }),
                                    icon: const Icon(
                                      Icons.check,
                                      color: fkDefaultColor,
                                    ))
                              ],
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
