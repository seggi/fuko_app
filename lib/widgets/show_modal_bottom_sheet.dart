import 'dart:convert';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

customBottomModalSheet(BuildContext context) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Create public notebook'),
              onTap: () {
                PagesGenerator.goTo(context, pathName: "/notebook");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('Add private dept notebook'),
              onTap: () {
                PagesGenerator.goTo(context, name: "add-borrow-manually");
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20.0)
          ],
        );
      });
}

customLoanBottomModalSheet(BuildContext context) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Create public notebook'),
              onTap: () {
                PagesGenerator.goTo(context, pathName: "/notebook");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('Add private loan notebook'),
              onTap: () {
                PagesGenerator.goTo(context, name: "add-lender-manually");
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20.0)
          ],
        );
      });
}

notebookCustomBottomModalSheet(BuildContext context,
    {fn, notebookMemberId, requestStatus, loading}) {
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              verticalSpaceRegular,
              ListTile(
                leading: const Icon(
                  Icons.cancel,
                  color: Colors.deepOrange,
                ),
                title: const Text('Cancel request'),
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  var token = await UserPreferences.getToken();

                  Map newItem = {
                    "method": "canceled",
                    "notebook_member_id": notebookMemberId,
                    "request_status": rejectRequest
                  };

                  final response = await http.put(
                      Uri.parse(Network.confirmRejectRequest),
                      headers: Network.authorizedHeaders(token: token),
                      body: jsonEncode(newItem));

                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body);
                    if (data["code"] == "success") {
                      PagesGenerator.goTo(context, pathName: "/notebook");
                      Navigator.pop(context);
                    } else {
                      PagesGenerator.goTo(context, pathName: "/notebook");
                      Navigator.pop(context);
                    }
                  } else {
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
    {fn, groupId, requestStatus, memberId, loading}) {
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              verticalSpaceRegular,
              ListTile(
                leading: const Icon(
                  Icons.cancel,
                  color: Colors.deepOrange,
                ),
                title: const Text('Cancel request'),
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  var token = await UserPreferences.getToken();

                  Map newItem = {
                    "id": memberId,
                    "request_status": rejectRequest
                  };

                  final response = await http.put(
                      Uri.parse(Network.confirmedCanceledGr),
                      headers: Network.authorizedHeaders(token: token),
                      body: jsonEncode(newItem));

                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body);
                    if (data["code"] == "success") {
                      PagesGenerator.goTo(context, pathName: "/groupe");
                      Navigator.pop(context);
                    } else {
                      PagesGenerator.goTo(context, pathName: "/groupe");
                      Navigator.pop(context);
                    }
                  } else {
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
