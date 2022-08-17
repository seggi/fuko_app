import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/notebook.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:fuko_app/widgets/show_modal_bottom_sheet.dart';

class IncomingRequest extends StatefulWidget {
  const IncomingRequest({Key? key}) : super(key: key);

  @override
  State<IncomingRequest> createState() => _IncomingRequestState();
}

class _IncomingRequestState extends State<IncomingRequest> {
  bool loading = false;
  bool loading1 = false;
  late String accepted = "accepted";
  late String rejected = "rejected";
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<Notebook>> retrieveIncomingRequest;

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future connect({notebookMemberId, requestStatus}) async {
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
    final response = await http.put(Uri.parse(Network.confirmRejectRequest),
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
        PagesGenerator.goTo(context, pathName: "/notebook");
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

  Future reject({notebookMemberId, requestStatus}) async {
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
    final response = await http.put(Uri.parse(Network.confirmRejectRequest),
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
        PagesGenerator.goTo(context, pathName: "/notebook");
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
  }

  @override
  void initState() {
    super.initState();
    retrieveIncomingRequest = fetchIncomingRequest();
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
                      onPressed: () =>
                          PagesGenerator.goTo(context, pathName: "/notebook"),
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
                  var dateTime =
                      DateTime.parse("${snapshot.data?[index].sentAt}");
                  return Card(
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
                                    text: '${snapshot.data?[index].username} ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const TextSpan(text: 'invited you to join '),
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
                                  "${dateTime.year}-${dateTime.month}-${dateTime.day}")
                            ],
                          ),
                          verticalSpaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              loading == false
                                  ? InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.link,
                                              color: Colors.blue,
                                            ),
                                            horizontalSpaceSmall,
                                            Text("Connect")
                                          ],
                                        ),
                                      ),
                                      onLongPress: () => connect(
                                          notebookMemberId:
                                              '${snapshot.data?[index].id}',
                                          requestStatus: 2),
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(left: 40.0),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                    ),
                              loading1 == false
                                  ? InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.link_off,
                                              color: Colors.red,
                                            ),
                                            horizontalSpaceSmall,
                                            Text("Reject")
                                          ],
                                        ),
                                      ),
                                      onLongPress: () => reject(
                                          notebookMemberId:
                                              '${snapshot.data?[index].id}',
                                          requestStatus: 3))
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      margin:
                                          const EdgeInsets.only(right: 40.0),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                    )
                            ],
                          )
                        ]),
                      ),
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
}
