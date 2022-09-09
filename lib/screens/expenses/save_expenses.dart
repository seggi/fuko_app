import 'dart:async';
import 'dart:convert';
import 'package:fuko_app/core/notification.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/budget_envelop_list.dart';
import 'package:fuko_app/widgets/popup/alert_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/widgets/popup/popup_dialog_4_expenses.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../../core/currency_data.dart';
import '../../widgets/bottom_sheet/currenncies.dart';

class SaveExpenses extends StatefulWidget {
  final String id;
  const SaveExpenses({Key? key, required this.id}) : super(key: key);

  @override
  State<SaveExpenses> createState() => _SaveExpensesState();
}

class _SaveExpensesState extends State<SaveExpenses> {
  late Future<List<GetCurrencies>> retrieveCurrencies;
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
  var clearWidgetList = FkManageProviders.save["remove-all-expenses"];

  void _removeAllData(BuildContext context) async {
    waitingOption(context, title: "Cleaning...");
    await Future.delayed(const Duration(seconds: 3));
    clearWidgetList(context);
    Navigator.of(context).pop();
  }

  Future saveExpenses(List expenseData) async {
    var token = await UserPreferences.getToken();
    var expenseId = widget.id;

    if (expenseData.isEmpty) {
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text(
          "No Expenses to save!",
          style: TextStyle(color: Colors.red),
        ),
      ));
    } else {
      waitingOption(context, title: "Please Wait...");
      final response = await http.post(
          Uri.parse(Network.addExpenses + "/$expenseId"),
          headers: Network.authorizedHeaders(token: token),
          body: jsonEncode({"data": expenseData}));
      if (response.statusCode == 200) {
        BackendFeedBack backendFeedBack =
            BackendFeedBack.fromJson(jsonDecode(response.body));

        if (backendFeedBack.code == "success") {
          clearWidgetList(context);
          PagesGenerator.goTo(context, pathName: "/expenses?status=true");
          FkManageProviders.remove['remove-envelope'](context);
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
  void initState() {
    super.initState();
    retrieveCurrencies = fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final List newItems = FkManageProviders.get(context)["add-expenses"];
    final totalAmount = FkManageProviders.get(context)["get-added-expenses"];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var getCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    final getEnvelope = FkManageProviders.get(context)['get-item-selected'];

    final removeEnvelope = FkManageProviders.remove['remove-envelope'];

    return FkScrollViewWidgets.body(context, itemList: [
      Container(
        padding: const EdgeInsets.all(20.0),
        height: height,
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () {
                        PagesGenerator.goTo(context, pathName: "/expenses");
                        removeEnvelope(context);
                      }),
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
                          onPressed: () => saveExpenses(newItems),
                          icon: const Icon(
                            Icons.save,
                            color: fkBlueText,
                            size: 28,
                          )),
                      BudgetEnvelopList(currencyCode: getCurrency)
                    ],
                  )
                ],
              ),
            ),
            verticalSpaceRegular,
            getEnvelope.isEmpty
                ? Container()
                : Container(
                    color: fkBlueLight,
                    child: ListTile(
                      leading: const Text(
                        'Envelope: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(getEnvelope['envelope'] ?? ""),
                      subtitle: Text(getEnvelope['amount'] ?? ""),
                    ),
                  ),
            verticalSpaceRegular,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: const Text(
                    "Add Expenses",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Container(
                      color: fkDefaultColor,
                      child: Row(
                        children: const [CurrencyButtonSheet()],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpaceSmall,
            const Divider(
              height: 2,
              color: fkDefaultColor,
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
            SizedBox(
              height: height / 2,
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
                                    FkManageProviders.save["remove-expenses"](
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
                                  onPressed: doNothings,
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
            verticalSpaceRegular,
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

doNothings(BuildContext context) {}
