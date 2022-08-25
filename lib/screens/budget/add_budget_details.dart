import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/budget_periode.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class AddBudgetDetails extends StatefulWidget {
  const AddBudgetDetails({Key? key}) : super(key: key);

  @override
  State<AddBudgetDetails> createState() => _AddBudgetDetailsState();
}

class _AddBudgetDetailsState extends State<AddBudgetDetails> {
  final _formKey = GlobalKey();
  bool loading = false;
  late Map getPeriod;
  late Map selectedItem;
  TextEditingController addBudgeAmountController = TextEditingController();

  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future saveBudgetEnvelop(
      {budgetCategory,
      envelopeAmount,
      budgetPeriod,
      defaultCurrency,
      getId,
      screenTitle,
      selectedCurrency}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var token = await UserPreferences.getToken();

    Map newItem = {
      "currency_id": selectedCurrency ?? defaultCurrency,
      "budget_category_id": budgetCategory,
      // "budget_period_id": budgetPeriod,
      "budget_option_id": expense.toString(),
      "budget_id": getId,
      "budget_amount": addBudgeAmountController.text,
    };

    if (addBudgeAmountController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "This field can't remain empty.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      setState(() {
        loading = true;
      });
      final response = await http.post(Uri.parse(Network.addEnvelope),
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
          PagesGenerator.goTo(context,
              name: "budget-detail", params: {"title": '$screenTitle'});
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
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];
    selectedItem = FkManageProviders.get(context)['get-item-selected'];
    final getId = FkManageProviders.get(context)['get-id'];

    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      getPeriod = FkManageProviders.get(context)['get-period-selected'];
    });

    return FkScrollViewWidgets.body(context, itemList: [
      Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () => PagesGenerator.goTo(context,
                          name: "budget-detail",
                          params: {"title": '$screenTitle'})),
                  const BudgetListSheet()
                ],
              ),
            ),
            verticalSpaceSmall,
            Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Add Envelope",
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
                    TextFormField(
                        autofocus: true,
                        // controller: addBudgeAmountController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        initialValue: selectedItem['name'],
                        decoration: InputDecoration(
                            hintText: 'Enter envelope title',
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: fkInputFormBorderColor, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0))),
                        onSaved: (String? value) {},
                        onTap: () => PagesGenerator.goTo(
                              context,
                              name: "search-budget-category",
                            )),
                    verticalSpaceSmall,
                    TextFormField(
                      autofocus: true,
                      controller: addBudgeAmountController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: 'Enter envelope amount',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: fkInputFormBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      onSaved: (String? value) {},
                    ),
                    verticalSpaceSmall,
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      decoration: BoxDecoration(
                          color: fkBlueLight,
                          border: Border.all(color: fkGreyText),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: getPeriod["budget"] == null
                                ? const Text(
                                    "Select period (Optional)",
                                    style: TextStyle(
                                        fontSize: 16, color: fkGreyText),
                                  )
                                : Text(
                                    getPeriod["budget"],
                                    style: const TextStyle(fontSize: 16),
                                  )),
                      ),
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
                            : () => saveBudgetEnvelop(
                                getId: getId,
                                screenTitle: screenTitle,
                                defaultCurrency: defaultCurrency,
                                selectedCurrency: setCurrency,
                                budgetCategory: selectedItem["id"],
                                budgetPeriod: getPeriod['id']),
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
          ]))
    ]);
  }
}
