import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/user.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class InviteFriendToNotebook extends StatefulWidget {
  late String? id;
  InviteFriendToNotebook({Key? key, this.id}) : super(key: key);

  @override
  State<InviteFriendToNotebook> createState() => _InviteFriendToNotebookState();
}

class _InviteFriendToNotebookState extends State<InviteFriendToNotebook> {
  final _formKey = GlobalKey();
  TextEditingController addBorrowerNameController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  bool loading = false;
  bool secondLoading = false;
  late List<dynamic> getFoundUser = [];
  late int requestStatus = 1;

  Future saveBorrowerName({
    notebookId,
    userId,
    borrowerName,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();

    Map newItem = {
      "notebook_id": notebookId,
      "request_status": requestStatus,
      "friend_id": userId.toInt()
    };

    final response = await http.post(Uri.parse(Network.inviteFriend),
        headers: Network.authorizedHeaders(token: token),
        body: jsonEncode(newItem));

    setState(() {
      secondLoading = true;
    });

    if (response.statusCode == 200) {
      setState(() {
        secondLoading = false;
      });
      PagesGenerator.goTo(context,
          name: "notebook-member", params: {"id": "$notebookId"});
    } else {
      setState(() {
        secondLoading = false;
      });
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text(
          "Error from server",
          style: TextStyle(color: Colors.red),
        ),
      ));
    }
  }

  Future searchUser() async {
    var token = await UserPreferences.getToken();
    Map newItem = {
      "username": addBorrowerNameController.text,
    };
    if (addBorrowerNameController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "You did not enter anything",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      setState(() {
        loading = true;
      });
      final response = await http.post(Uri.parse(Network.searchUser),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode(newItem));

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          NewBorrower newBorrowerData =
              NewBorrower.fromJson(jsonDecode(response.body));
          FkManageProviders.save["save_new_borrower"](context,
              itemData: {"data": newBorrowerData.userData});
          getFoundUser = newBorrowerData.userData;
        });
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
    final notebookId = widget.id;
    final borrowers = getFoundUser.isEmpty ? [] : getFoundUser;

    return FkScrollViewWidgets.body(context, itemList: [
      Container(
          padding: const EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () => PagesGenerator.goTo(context,
                          name: "notebook-member",
                          params: {"id": '$notebookId'})),
                ],
              ),
            ),
            verticalSpaceMedium,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Search friend",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            autofocus: true,
                            controller: addBorrowerNameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10),
                                hintText: 'Enter friend name',
                                border: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: fkInputFormBorderColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0))),
                            onSaved: (String? value) {},
                          ),
                        ),
                        horizontalSpaceSmall,
                        InkWell(
                          onTap: loading == false ? () => searchUser() : () {},
                          child: loading == false
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(Icons.search_sharp))
                              : const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: borrowers.isEmpty
                        ? const SizedBox(
                            child: Center(
                                child:
                                    Text("No person found with that name...")),
                          )
                        : ListView.builder(
                            itemCount: borrowers.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.account_circle_outlined),
                                  title:
                                      Text("${borrowers[index]["username"]}"),
                                  subtitle: Text(
                                      "${borrowers[index]["last_name"]} ${borrowers[index]["first_name"]}"),
                                  trailing: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: fkDefaultColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2.0,
                                            color: fkDefaultColor,
                                          )),
                                      child: InkWell(
                                        onTap: secondLoading == false
                                            ? () => saveBorrowerName(
                                                notebookId: notebookId,
                                                userId: borrowers[index]["id"],
                                                borrowerName:
                                                    "${borrowers[index]["last_name"]} ${borrowers[index]["first_name"]}")
                                            : () {},
                                        child: secondLoading == false
                                            ? const Icon(
                                                Icons.add,
                                                color: fkGreyText,
                                              )
                                            : const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  color: fkWhiteText,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
                ],
              ),
            )
          ]))
    ]);
  }
}
