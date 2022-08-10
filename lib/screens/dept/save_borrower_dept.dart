import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/core/notification.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/popup/alert_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/widgets/popup/popup_dialog_4_dept.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class RecordBorrowerDept extends StatefulWidget {
  final String id;
  const RecordBorrowerDept({Key? key, required this.id}) : super(key: key);

  @override
  State<RecordBorrowerDept> createState() => _RecordBorrowerDeptState();
}

class _RecordBorrowerDeptState extends State<RecordBorrowerDept> {
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  var clearWidgetList = FkManageProviders.save["remove-all-dept"];

  void _removeAllData(BuildContext context) async {
    waitingOption(context, title: "Cleaning...");
    await Future.delayed(const Duration(seconds: 3));
    clearWidgetList(context);
    Navigator.of(context).pop();
  }

  Future saveDept(List deptData) async {
    var token = await UserPreferences.getToken();
    var noteId = widget.id;

    if (deptData.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text(
          "No Dept to save!",
          style: TextStyle(color: Colors.red),
        ),
      ));
    } else {
      waitingOption(context, title: "Please Wait...");

      final response = await http.post(
          Uri.parse(Network.recordDept + "/$noteId"),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode({"data": deptData}));

      if (response.statusCode == 200) {
        BackendFeedBack backendFeedBack =
            BackendFeedBack.fromJson(jsonDecode(response.body));

        if (backendFeedBack.code == "success") {
          clearWidgetList(context);
          PagesGenerator.goTo(context,
              name: "borrower_dept_details", params: {"id": widget.id});
          Navigator.of(context).pop();
        } else {
          scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text(
              "Failed to save data",
              style: TextStyle(color: Colors.red),
            ),
          ));
          Navigator.of(context).pop();
        }
      } else {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
            "Error from server",
            style: TextStyle(color: Colors.red),
          ),
        ));
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deptCategoryId = widget.id;
    final List newItems = FkManageProviders.get(context)["get-added-dept"];
    final totalAmount = FkManageProviders.get(context)["get-total-dept-amount"];

    return FkScrollViewWidgets.body(context, itemList: [
      Container(
        padding: const EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () => PagesGenerator.goTo(context,
                          name: "borrower_dept_details",
                          params: {"id": deptCategoryId})),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => _removeAllData(context),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 28,
                          )),
                      IconButton(
                          onPressed: () => saveDept(newItems),
                          icon: const Icon(
                            Icons.save,
                            color: fkBlueText,
                            size: 28,
                          ))
                    ],
                  )
                ],
              ),
            ),
            verticalSpaceRegular,
            Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Record Dept",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            verticalSpaceRegular,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Amount",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            verticalSpaceRegular,
            Expanded(
              child: newItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: newItems.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                            key: UniqueKey(),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(
                                  key: UniqueKey(),
                                  onDismissed: () {
                                    FkManageProviders.save["remove-dept"](
                                        context,
                                        itemData: {
                                          "description": newItems[index]
                                              ['description'],
                                          "amount": double.parse(
                                              newItems[index]['amount'])
                                        });
                                  }),
                              children: const [
                                SlidableAction(
                                  onPressed: doNothingsOne,
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Remove',
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.delete_sweep,
                                color: fkBlueText,
                              ),
                              title: Text(newItems[index]['description']),
                              trailing: Text(
                                  "${double.parse(newItems[index]['amount'])}"),
                            ));
                      },
                    )
                  : const Center(
                      child: Text("Empty List"),
                    ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: fkGreyText))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    totalAmount.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            verticalSpaceLarge,
            Container(
              decoration: BoxDecoration(
                  color: fkDefaultColor,
                  borderRadius: BorderRadius.circular(8.0)),
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: TextButton(
                      onPressed: () => showDialogWithFields(
                            context,
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.data_saver_on,
                            color: fkWhiteText,
                          ),
                          horizontalSpaceSmall,
                          Text(
                            "New Item",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: fkWhiteText),
                          ),
                        ],
                      ))),
            ),
          ],
        ),
      )
    ]);
  }
}

doNothingsOne(BuildContext context) {}
