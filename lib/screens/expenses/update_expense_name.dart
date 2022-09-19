import 'dart:convert';
import 'package:fuko_app/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../controllers/manage_provider.dart';
import '../../controllers/page_generator.dart';
import '../../core/user_preferences.dart';
import '../../utils/api.dart';
import '../../widgets/shared/style.dart';
import '../../widgets/shared/ui_helper.dart';
import '../content_box_widgets.dart';

class UpdateExpenseName extends StatefulWidget {
  final String? expenseId;
  final String? screenType;
  const UpdateExpenseName({Key? key, this.expenseId, this.screenType})
      : super(key: key);

  @override
  State<UpdateExpenseName> createState() => _UpdateExpenseNameState();
}

class _UpdateExpenseNameState extends State<UpdateExpenseName> {
  final _formKey = GlobalKey();
  bool loading = false;

  TextEditingController expenseNameController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future updateExpenseName(expenseId, expenseDescriptionId) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();

    if (expenseNameController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "Please fill all fields.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));

      return;
    } else {
      setState(() {
        loading = true;
      });

      if (expenseDescriptionId.isEmpty) {
        Map newItem = {
          "expense_name": expenseNameController.text,
        };

        final response = await http.put(
            Uri.parse(Network.updateExpenseName + "/$expenseId"),
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

      if (expenseDescriptionId.isNotEmpty) {
        Map descriptionData = {
          "amount": expenseAmountController.text,
          "description": expenseNameController.text,
          "currency_id": expenseDescriptionId['currency_id']
        };

        var id = expenseDescriptionId['id'];

        final response = await http.put(
            Uri.parse(Network.updateExpenseDetails + "/$id"),
            headers: Network.authorizedHeaders(token: token),
            body: jsonEncode(descriptionData));

        if (response.statusCode == 200) {
          PagesGenerator.goTo(context,
              name: "expense-list", params: {"id": widget.expenseId!});
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
  }

  @override
  Widget build(BuildContext context) {
    final expenseId = widget.expenseId;
    final screenType = widget.screenType;
    final expenseDescriptionId =
        FkManageProviders.get(context)['get-expense-descriptionId'];
    print(expenseDescriptionId);
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];

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
                      onPressed: () {
                        if (screenType == editExpenseTitle) {
                          PagesGenerator.goTo(context, pathName: "/expenses");
                        }

                        if (screenType == editExpenseDescription) {
                          PagesGenerator.goTo(context,
                              name: "expense-list", params: {"id": expenseId!});
                        }
                      })
                ],
              ),
            ),
            verticalSpaceLarge,
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                screenType == editExpenseTitle
                    ? "Edit expense title"
                    : "Edit expense  description",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    expenseDescriptionId != null ||
                            expenseDescriptionId.isNotEmpty
                        ? TextFormField(
                            autofocus: true,
                            controller: expenseNameController
                              ..text = expenseDescriptionId['name'],
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: 'Expense name',
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: fkInputFormBorderColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0))),
                            onSaved: (String? value) {},
                          )
                        : Container(),
                    expenseDescriptionId == null
                        ? TextFormField(
                            autofocus: true,
                            controller: expenseNameController
                              ..text = screenTitle,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: 'Expense name',
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: fkInputFormBorderColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0))),
                            onSaved: (String? value) {},
                          )
                        : Container(),
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
                        onPressed: () =>
                            updateExpenseName(expenseId, expenseDescriptionId),
                        child: loading == false
                            ? const Icon(
                                Icons.mode_edit,
                                color: fkWhiteText,
                              )
                            : const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  backgroundColor: fkWhiteText,
                                ),
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
