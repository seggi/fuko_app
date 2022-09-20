import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../controllers/manage_provider.dart';
import '../../controllers/page_generator.dart';
import '../../core/user_preferences.dart';
import '../../utils/api.dart';
import '../../widgets/shared/style.dart';
import '../../widgets/shared/ui_helper.dart';
import '../content_box_widgets.dart';

class UpdateSaving extends StatefulWidget {
  const UpdateSaving({Key? key}) : super(key: key);

  @override
  State<UpdateSaving> createState() => _UpdateSavingState();
}

class _UpdateSavingState extends State<UpdateSaving> {
  final _formKey = GlobalKey();
  bool loading = false;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future updateExpenseName(
    savingData,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();
    var savingId = savingData["id"];
    Map newItem = {
      "description": descriptionController.text,
      "amount": amountController.text,
    };

    if (descriptionController.text == "") {
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

      final response = await http.put(
          Uri.parse(Network.updateSaving + "/$savingId"),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode(newItem));

      if (response.statusCode == 200) {
        PagesGenerator.goTo(context, pathName: "/saving?status=true");
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
    final getSaving = FkManageProviders.get(context)['get-item-selected'];

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
                          pathName: "/saving?status=true"))
                ],
              ),
            ),
            verticalSpaceLarge,
            Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Edit saving",
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
                      controller: descriptionController
                        ..text = getSaving['description'],
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'Saving name',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: fkInputFormBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      onSaved: (String? value) {},
                    ),
                    verticalSpaceRegular,
                    TextFormField(
                      autofocus: true,
                      controller: amountController..text = getSaving['amount'],
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'Saving amount',
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
                        onPressed: () => updateExpenseName(getSaving),
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
