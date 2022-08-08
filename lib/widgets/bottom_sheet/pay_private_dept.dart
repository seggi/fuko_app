import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:http/http.dart' as http;

class PayPrivateDept extends StatefulWidget {
  const PayPrivateDept({Key? key}) : super(key: key);

  @override
  State<PayPrivateDept> createState() => _PayPrivateDeptState();
}

class _PayPrivateDeptState extends State<PayPrivateDept> {
  final _formKey = GlobalKey();
  bool loading = false;

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future savePaidAmount({currencyCode}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();
    Map newItem = {
      "data": {
        "amount": double.parse(amountController.text),
        "description": descriptionController.text == ""
            ? deptPaymentLabel
            : descriptionController.text,
        "currency_id": currencyCode
      },
      "method": "single"
    };

    if (amountController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "Please fill amount field.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      setState(() {
        loading = true;
      });
      final response = await http.post(
          Uri.parse("${Network.personalManageDept}/"),
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
          PagesGenerator.goTo(context, pathName: "/dept?status=true");
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
    final borrowerId = FkManageProviders.get(context)['get-borrower-id'];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Expanded(
                  child: Column(
                    children: [
                      verticalSpaceSmall,
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  color: fkGreyText,
                                ),
                                onPressed: () => Navigator.pop(context)),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(children: [
                          verticalSpaceLarge,
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: const Text(
                              "Dept payment",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
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
                                                color: fkInputFormBorderColor,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(8.0))),
                                    onSaved: (String? value) {},
                                  ),
                                  verticalSpaceMedium,
                                  TextFormField(
                                    autofocus: true,
                                    controller: descriptionController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        hintText: 'Description',
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: fkInputFormBorderColor,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(8.0))),
                                    onSaved: (String? value) {},
                                  ),
                                  verticalSpaceMedium,
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: fkDefaultColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          width: 2.0,
                                          color: fkDefaultColor,
                                        )),
                                    child: TextButton(
                                      onPressed: loading == true
                                          ? () {}
                                          : () => savePaidAmount(
                                              currencyCode: setCurrency),
                                      child: loading == false
                                          ? const Icon(
                                              Icons.add,
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
                        ]),
                      ))
                    ],
                  ),
                ),
              );
            });
      },
      child: const Icon(
        Icons.payment,
        size: 20,
        color: fkBlueText,
      ),
    );
  }
}
