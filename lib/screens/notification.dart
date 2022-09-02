import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/notebook.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  bool loading = false;
  bool loading1 = false;
  late String accepted = "accepted";
  late String rejected = "rejected";
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<Notebook>> retrieveIncomingRequest;

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  @override
  void initState() {
    super.initState();
    retrieveIncomingRequest = fetchIncomingRequest(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FkContentBoxWidgets.body(context, 'notebook', itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      iconSize: 18,
                      onPressed: () => PagesGenerator.goTo(context,
                          pathName: "/?status=true"),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      )),
                  const Text(
                    "Request received",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: const [],
              )
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        verticalSpaceRegular,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Pending requests",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceRegular,
      ]),
      Expanded(
        child: FutureBuilder(
          future: retrieveIncomingRequest,
          builder: (context, AsyncSnapshot<List<Notebook>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No pending request.'),
                );
              }

              FkManageProviders.save["save-request-number"](context,
                  number: "${snapshot.data!.length}");
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

                  return snapshot.data?[index].notification == "notebook"
                      ? Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: const Icon(
                              Icons.message,
                              size: 30,
                              color: fkBlueText,
                            ),
                            title: SizedBox(
                                width: 200,
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              '${snapshot.data?[index].username} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(
                                          text: 'invited you to join '),
                                      TextSpan(
                                          text:
                                              '${snapshot.data?[index].notebookName} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(text: 'notebook.')
                                    ],
                                  ),
                                )),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(children: [
                                Row(
                                  children: [
                                    const Text("Sent at "),
                                    Text(
                                        "${DateTime.parse("${snapshot.data?[index].sentAt}").year}-${DateTime.parse("${snapshot.data?[index].sentAt}").month}-${DateTime.parse("${snapshot.data?[index].sentAt}").day}")
                                  ],
                                ),
                                verticalSpaceRegular,
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.add_reaction_outlined,
                                      color: Colors.blue,
                                    ),
                                    horizontalSpaceSmall,
                                    Text("React")
                                  ],
                                ),
                              ]),
                            ),
                            onTap: () => noteCustomBottomModalSheet(context,
                                requestStatus: 3,
                                notebookMemberId:
                                    '${snapshot.data?[index].notebookName}'),
                          ),
                        )
                      : Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: const Icon(
                              Icons.message,
                              size: 30,
                              color: fkBlueText,
                            ),
                            title: SizedBox(
                                width: 200,
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              '${snapshot.data?[index].username} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(
                                          text: 'invited you to join '),
                                      TextSpan(
                                          text:
                                              '${snapshot.data?[index].groupName} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(text: 'group.')
                                    ],
                                  ),
                                )),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(children: [
                                Row(
                                  children: [
                                    const Text("Sent at "),
                                    Text(
                                        "${DateTime.parse("${snapshot.data?[index].requestedAt}").year}-${DateTime.parse("${snapshot.data?[index].requestedAt}").month}-${DateTime.parse("${snapshot.data?[index].requestedAt}").day}")
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.add_reaction_outlined,
                                      color: Colors.blue,
                                    ),
                                    horizontalSpaceSmall,
                                    Text("React")
                                  ],
                                )
                              ]),
                            ),
                            onTap: () => grCustomBottomModalSheet(context,
                                memberShipId: '${snapshot.data?[index].id}',
                                loading: loading1,
                                requestStatus: 3),
                          ),
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
      ),
    ]));
  }

  noteCustomBottomModalSheet(BuildContext context,
      {fn, notebookMemberId, requestStatus, loading}) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.link,
                    color: Colors.blue,
                  ),
                  title: const Text('Confirm'),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var token = await UserPreferences.getToken();
                    Map newItem = {
                      "method": accepted,
                      "notebook_member_id": notebookMemberId,
                      "request_status": requestStatus
                    };

                    setState(() {
                      loading = true;
                    });
                    final response = await http.put(
                        Uri.parse(Network.confirmRejectRequest),
                        headers: Network.authorizedHeaders(token: token),
                        body: jsonEncode(newItem));

                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      if (data["code"] == "Alert") {
                        setState(() {
                          loading = false;
                        });
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(
                            "${data["message"]}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ));
                      } else {
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                        Navigator.pop(context);
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
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.link_off,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Cancel request'),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var token = await UserPreferences.getToken();
                    Map newItem = {
                      "method": rejected,
                      "notebook_member_id": notebookMemberId,
                      "request_status": requestStatus
                    };

                    setState(() {
                      loading1 = true;
                    });
                    final response = await http.put(
                        Uri.parse(Network.confirmRejectRequest),
                        headers: Network.authorizedHeaders(token: token),
                        body: jsonEncode(newItem));

                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      if (data["code"] == "Alert") {
                        setState(() {
                          loading1 = false;
                        });
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(
                            "${data["message"]}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ));
                      } else {
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                      }
                    } else {
                      setState(() {
                        loading1 = false;
                      });
                      scaffoldMessenger.showSnackBar(const SnackBar(
                        content: Text(
                          "Error from server",
                          style: TextStyle(color: Colors.red),
                        ),
                      ));
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  grCustomBottomModalSheet(BuildContext context,
      {memberShipId, requestStatus, loading, method}) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.link,
                    color: Colors.blue,
                  ),
                  title: const Text('Confirm'),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var token = await UserPreferences.getToken();
                    Map newItem = {
                      "id": memberShipId,
                      "request_status": requestStatus
                    };

                    setState(() {
                      loading = true;
                    });
                    final response = await http.put(
                        Uri.parse(Network.confirmedCanceledGr),
                        headers: Network.authorizedHeaders(token: token),
                        body: jsonEncode(newItem));

                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      if (data["code"] == "Alert") {
                        setState(() {
                          loading = false;
                        });
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(
                            "${data["message"]}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ));
                      } else {
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                        Navigator.pop(context);
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
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.link_off,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Reject'),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var token = await UserPreferences.getToken();
                    Map newItem = {
                      "id": memberShipId,
                      "request_status": requestStatus
                    };

                    setState(() {
                      loading1 = true;
                    });
                    final response = await http.put(
                        Uri.parse(Network.confirmedCanceledGr),
                        headers: Network.authorizedHeaders(token: token),
                        body: jsonEncode(newItem));

                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      if (data["code"] == "Alert") {
                        setState(() {
                          loading1 = false;
                        });
                        scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(
                            "${data["message"]}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ));
                      } else {
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                        Navigator.pop(context);
                      }
                    } else {
                      setState(() {
                        loading1 = false;
                      });
                      scaffoldMessenger.showSnackBar(const SnackBar(
                        content: Text(
                          "Error from server",
                          style: TextStyle(color: Colors.red),
                        ),
                      ));
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
