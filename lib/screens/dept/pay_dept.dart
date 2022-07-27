import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/notification.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class PayDept extends StatefulWidget {
  final String id;
  const PayDept({Key? key, required this.id}) : super(key: key);

  @override
  State<PayDept> createState() => _PayDeptState();
}

class _PayDeptState extends State<PayDept> {
  final _formKey = GlobalKey();

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future saveExpenses() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();
    var userId = await UserPreferences.getUserId();
    Map newItem = {
      "amount": amountController.text,
      "description": descriptionController.text
    };

    if (amountController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "Please fill all fields.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      final response = await http.post(
          Uri.parse(Network.createExpense + "/$userId"),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode(newItem));

      if (response.statusCode == 200) {
        PagesGenerator.goTo(context, pathName: "/dept?status=true");
      } else {
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
    final borrowerId = FkManageProviders.get(context)['get-borrower-id'];

    return FkScrollViewWidgets.body(context, itemList: [
      Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () => PagesGenerator.goTo(context,
                          name: "borrower_dept_details",
                          params: {"id": borrowerId})),
                ],
              ),
            ),
            verticalSpaceLarge,
            Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Pay",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: 'Amount',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: fkInputFormBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      onSaved: (String? value) {},
                    ),
                    verticalSpaceMedium,
                    TextFormField(
                      autofocus: true,
                      controller: amountController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: fkInputFormBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      onSaved: (String? value) {},
                    ),
                    verticalSpaceMedium,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: fkDefaultColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            width: 2.0,
                            color: fkDefaultColor,
                          )),
                      child: TextButton(
                        onPressed: () => saveExpenses(),
                        child: const Icon(
                          Icons.add,
                          color: fkWhiteText,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]))
    ]);
  }
}
