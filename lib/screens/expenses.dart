import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/expenses.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../core/currency_data.dart';
import '../utils/constant.dart';
import '../widgets/bottom_sheet/currenncies.dart';

class ExpensesPage extends StatefulWidget {
  final String? status;

  const ExpensesPage({Key? key, required this.status}) : super(key: key);

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

// RetrieveExpensesTotal

  late Future<RetrieveExpensesTotal> retrieveExpensesTotal;
  late Future<List<RetrieveExpenses>> retrieveExpenses;

  @override
  void initState() {
    super.initState();
    retrieveCurrencies = fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    final screenTitle = FkManageProviders.save["save-screen-title"];

    if (widget.status == "true") {
      setState(() {
        retrieveExpensesTotal =
            fetchRetrieveExpensesTotal(currencyId: setCurrency);
        retrieveExpenses = fetchRetrieveExpenses(currencyId: setCurrency);
      });
    }
    return FkContentBoxWidgets.body(context, 'savings', itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  const Text(
                    "Expense",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () =>
                          PagesGenerator.goTo(context, name: "create-expense"),
                      icon: const Icon(
                        Icons.add_circle,
                        color: fkBlackText,
                      )),
                  IconButton(
                      onPressed: () =>
                          PagesGenerator.goTo(context, name: "expense-report"),
                      icon: const Icon(
                        Icons.manage_history,
                        color: fkBlackText,
                        size: 20,
                      )),
                ],
              )
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        verticalSpaceRegular,
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<RetrieveExpensesTotal>(
                future: fetchRetrieveExpensesTotal(currencyId: setCurrency),
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Total Expense Amount",
                                  style: TextStyle(
                                      color: fkBlackText,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                              verticalSpaceTiny,
                              Text(
                                "${snapshot.data!.totalAmount}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: fkBlackText),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Container(
                                color: fkDefaultColor,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${snapshot.data!.currencyCode}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: fkWhiteText),
                                      ),
                                    ),
                                    const CurrencyButtonSheet(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                            child: Text(
                          snapshot.error != null
                              ? "Failed to load data"
                              : "Amount not available...",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: fkGreyText),
                        )),
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
                        )
                      ],
                    ));
                  }
                  return Container(
                      padding: const EdgeInsets.all(20.0),
                      child: const Center(
                          child: Text(
                        "Loading Amount...",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: fkGreyText),
                      )));
                },
              ),
            ],
          ),
        ),
      ]),
      Expanded(
        child: FutureBuilder(
          future: fetchRetrieveExpenses(currencyId: setCurrency),
          builder: (context, AsyncSnapshot<List<RetrieveExpenses>> snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification:
                      (OverscrollIndicatorNotification? overscroll) {
                    overscroll!.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var dateTime =
                          DateTime.parse("${snapshot.data?[index].createdAt}");
                      return Card(
                        child: Slidable(
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                  flex: 2,
                                  icon: Icons.update,
                                  label: "Edit title",
                                  backgroundColor: updateBtnColor,
                                  onPressed: ((context) {
                                    //! save-expense-descriptionId
                                    screenTitle(context,
                                        screenTitle:
                                            "${snapshot.data?[index].expenseName}");
                                    PagesGenerator.goTo(context,
                                        name: "update-expense-name",
                                        params: {
                                          "screenType": editExpenseTitle,
                                          "id":
                                              "${snapshot.data?[index].expenseId}"
                                        });
                                  }))
                            ],
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.notes,
                              color: fkBlueText,
                            ),
                            title: SizedBox(
                              width: 200,
                              child: Text(
                                snapshot.data?[index].expenseName ??
                                    "No title provided",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  PagesGenerator.goTo(context,
                                      name: "save-expenses",
                                      params: {
                                        "id":
                                            "${snapshot.data?[index].expenseId}"
                                      });
                                },
                                icon: const Icon(
                                  Icons.post_add_outlined,
                                  color: fkDefaultColor,
                                )),
                            onTap: () {
                              screenTitle(context,
                                  screenTitle:
                                      "${snapshot.data?[index].expenseName}");

                              PagesGenerator.goTo(context,
                                  name: "expense-list",
                                  params: {
                                    "id": "${snapshot.data?[index].expenseId}"
                                  });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong :('));
            }
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      ),
    ]);
  }
}
