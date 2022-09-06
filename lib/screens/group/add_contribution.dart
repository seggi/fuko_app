import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class AddContribution extends StatefulWidget {
  const AddContribution({Key? key}) : super(key: key);

  @override
  State<AddContribution> createState() => _AddContributionState();
}

class _AddContributionState extends State<AddContribution> {
  final _formKey = GlobalKey();
  bool loading = false;
  late Map getPeriod;
  late Map selectedItem;
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future addContribution(
      {selectedCurrency, groupId, List? members = const []}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();

    List<Map> newItem = [
      {
        "amount": amountController.text,
        "currency_id": selectedCurrency,
        "description": descriptionController.text
      },
      {"members": members}
    ];

    if (amountController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "Amount field can't remain empty.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    }
    if (descriptionController.text.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "Description field can't remain empty.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      setState(() {
        loading = true;
      });
      final response = await http.post(
          Uri.parse("${Network.saveGroupContributor}/$groupId"),
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
              style: const TextStyle(color: fkWhiteText),
            ),
          ));
          FkManageProviders.remove['remove-items'](context);
        } else {
          PagesGenerator.goTo(context, name: "groupe-detail");
          FkManageProviders.remove['remove-items'](context);
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
  }

  @override
  Widget build(BuildContext context) {
    final groupId = FkManageProviders.get(context)['get-id'];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();
    final List newItems = FkManageProviders.get(context)["get-list-items"];

    return FkScrollViewWidgets.body(
      context,
      itemList: [
        Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.cancel_outlined),
                        onPressed: () {
                          PagesGenerator.goTo(context, name: "groupe-detail");
                          FkManageProviders.remove['remove-items'](context);
                        }),
                    IconButton(
                        onPressed: () => PagesGenerator.goTo(context,
                            name: "edit-participator",
                            params: {"groupId": groupId}),
                        icon: const Icon(
                          Icons.edit_note_outlined,
                          color: fkBlueText,
                          size: 28,
                        ))
                  ],
                ),
              ),
              verticalSpaceSmall,
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Add contribution",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              verticalSpaceMedium,
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      verticalSpaceSmall,
                      TextFormField(
                        autofocus: true,
                        controller: amountController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: 'Enter amount',
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: fkInputFormBorderColor, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0))),
                        onSaved: (String? value) {},
                      ),
                      verticalSpaceRegular,
                      TextFormField(
                        autofocus: true,
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: 'Enter description',
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: fkInputFormBorderColor, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0))),
                        onSaved: (String? value) {},
                      ),
                      verticalSpaceLarge,
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
                          onPressed: loading == true
                              ? () {}
                              : () => addContribution(
                                  selectedCurrency: setCurrency,
                                  groupId: groupId,
                                  members: newItems),
                          child: loading == false
                              ? const Icon(
                                  Icons.add_circle,
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
            ],
          ),
        )
      ],
    );
  }
}
