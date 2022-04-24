import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/notification.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/accountability/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class CreateExpense extends StatefulWidget {
  const CreateExpense({Key? key}) : super(key: key);

  @override
  State<CreateExpense> createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  final _formKey = GlobalKey();

  TextEditingController expenseNameController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future saveExpenses() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();
    var userId = await UserPreferences.getUserId();
    Map newItem = {
      "expense_name": expenseNameController.text,
    };

    if (expenseNameController.text == "") {
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
        PagesGenerator.goTo(context, pathName: "/expenses?status=true");
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
                      onPressed: () =>
                          PagesGenerator.goTo(context, pathName: "/expenses")),
                ],
              ),
            ),
            verticalSpaceLarge,
            Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Create Expense",
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
                      controller: expenseNameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: 'Expense Title',
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
