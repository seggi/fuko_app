import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/notification.dart';
import 'package:fuko_app/core/profile.dart';
import 'package:fuko_app/core/settings.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
import 'package:fuko_app/widgets/popup/alert_dialog.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:http/http.dart' as http;

class ConfigCurrency extends StatefulWidget {
  const ConfigCurrency({Key? key}) : super(key: key);

  @override
  State<ConfigCurrency> createState() => _ConfigCurrencyState();
}

class _ConfigCurrencyState extends State<ConfigCurrency> {
  bool loading = false;
  late Future<List<Settings>>? retrieveCurrency;
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  late bool isEditDefaultCurrency = false;
  late bool isEditGroupDefaultCurrency = false;

  @override
  void initState() {
    retrieveCurrency = fetchCurrency();
    isEditDefaultCurrency = false;
    isEditGroupDefaultCurrency = false;
    super.initState();
  }

  Future save({selectedCurrency}) async {
    var token = await UserPreferences.getToken();
    Map<String, dynamic> userData = {"currency_id": selectedCurrency};
    if (selectedCurrency.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text(
          "Please select a currency",
          style: TextStyle(color: Colors.red),
        ),
      ));
    } else {
      setState(() {
        loading = true;
      });
      final response = await http.post(Uri.parse(Network.setDefaultCurrency),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode(userData));

      if (response.statusCode == 200) {
        BackendFeedBack backendFeedBack =
            BackendFeedBack.fromJson(jsonDecode(response.body));

        if (backendFeedBack.code == "success") {
          var data = jsonDecode(response.body);

          setState(() {
            loading = false;
            retrieveCurrency = fetchCurrency();
          });
          scaffoldMessenger.showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "${data["message"]}",
              style: const TextStyle(color: Colors.white),
            ),
          ));
        } else {
          setState(() {
            loading = false;
          });
          scaffoldMessenger.showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Failed to save data",
              style: TextStyle(color: Colors.white),
            ),
          ));
        }
      } else {
        setState(() {
          loading = false;
        });
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
            "Error from server",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    }
  }

  Future updateCurrency({selectedCurrency}) async {
    var token = await UserPreferences.getToken();
    Map<String, dynamic> userData = {"currency_id": selectedCurrency};
    if (selectedCurrency.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text(
          "Please select a currency",
          style: TextStyle(color: Colors.red),
        ),
      ));
    } else {
      setState(() {
        loading = true;
      });
      final response = await http.put(Uri.parse(Network.changeDefaultCurrency),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode(userData));
      if (response.statusCode == 200) {
        BackendFeedBack backendFeedBack =
            BackendFeedBack.fromJson(jsonDecode(response.body));

        if (backendFeedBack.code == "success") {
          var data = jsonDecode(response.body);

          setState(() {
            loading = false;
            retrieveCurrency = fetchCurrency();
          });
          scaffoldMessenger.showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "${data["message"]}",
              style: const TextStyle(color: Colors.white),
            ),
          ));
        } else {
          setState(() {
            loading = false;
          });
          scaffoldMessenger.showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Failed to save data",
              style: TextStyle(color: Colors.white),
            ),
          ));
        }
      } else {
        setState(() {
          loading = false;
        });
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
            "Error from server",
            style: TextStyle(color: Colors.red),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    return Column(
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
              FutureBuilder(
                future: retrieveCurrency,
                builder: (context, AsyncSnapshot<List<Settings>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return isEditDefaultCurrency == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("No default currency set!.",
                                    style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                IconButton(
                                    onPressed: () => setState(() {
                                          isEditDefaultCurrency = true;
                                        }),
                                    icon: const Icon(
                                      Icons.add_circle_outline,
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
                                        child: const Text("Select a currency",
                                            style: TextStyle(
                                                color: fkWhiteText,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
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
                                loading == false
                                    ? IconButton(
                                        onPressed: () {
                                          save(
                                              selectedCurrency:
                                                  selectedCurrency);
                                          setState(() {
                                            isEditDefaultCurrency = false;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.check,
                                          color: fkDefaultColor,
                                        ))
                                    : const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                              ],
                            );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No pending request.'),
                          );
                        }

                        // return Text('${snapshot.data?[index].code}');
                        return isEditDefaultCurrency == false
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${snapshot.data?[index].code}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isEditDefaultCurrency = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: fkDefaultColor,
                                      ))
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          child: const Text("Select a currency",
                                              style: TextStyle(
                                                  color: fkWhiteText,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12)),
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
                                  loading == false
                                      ? IconButton(
                                          onPressed: () {
                                            updateCurrency(
                                                selectedCurrency:
                                                    selectedCurrency);
                                            setState(() {
                                              isEditDefaultCurrency = false;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            color: fkDefaultColor,
                                          ))
                                      : const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                ],
                              );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong :('));
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    ),
                  );
                },
              ),
              verticalSpaceSmall,
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
                                fontWeight: FontWeight.w600, fontSize: 16)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
