import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/group.dart';
import 'package:fuko_app/core/notebook.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class GroupMember extends StatefulWidget {
  final String id;
  const GroupMember({Key? key, required this.id}) : super(key: key);

  @override
  State<GroupMember> createState() => _GroupMemberState();
}

class _GroupMemberState extends State<GroupMember> {
  bool loading1 = false;
  bool loading = false;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<GroupData>> retrieveGroupMember;

  @override
  void initState() {
    super.initState();
    retrieveGroupMember = fetchGroupMember(groupId: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final groupId = widget.id;
    setState(() {
      retrieveGroupMember = fetchGroupMember(groupId: groupId);
    });

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
                      PagesGenerator.goTo(context, name: "groupe-detail"),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
                const Text(
                  "Group member",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
      Expanded(
        child: FutureBuilder(
          future: retrieveGroupMember,
          builder: (context, AsyncSnapshot<List<GroupData>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No member found.'),
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
                      child: Text('No member found.'),
                    );
                  }

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: fkGreyText,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: fkWhiteText,
                          ),
                        ),
                        title: SizedBox(
                          width: 200,
                          child: Text(
                            "${snapshot.data?[index].username}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          "${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
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

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  deptFn({required String notebookMemberId}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();
    Map newItem = {"memeber_id": notebookMemberId};

    setState(() {
      loading = true;
    });

    final response = await http.post(
        Uri.parse(Network.linkNotebookMemberToDeptNotebook),
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
        PagesGenerator.goTo(context, pathName: "/dept");
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

  loanFn({required String notebookMemberId}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();
    Map newItem = {"friend_id": notebookMemberId};

    setState(() {
      loading1 = true;
    });

    final response = await http.post(
        Uri.parse(Network.linkNotebookMemberToLoanNotebook),
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
        PagesGenerator.goTo(context, pathName: "/loan");
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
}
