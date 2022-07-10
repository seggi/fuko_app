import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/expenses.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:intl/intl.dart';

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
    retrieveExpensesTotal = fetchRetrieveExpensesTotal();
    retrieveExpenses = fetchRetrieveExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.save["save-screen-title"];

    if (widget.status == "true") {
      setState(() {
        retrieveExpensesTotal = fetchRetrieveExpensesTotal();
        retrieveExpenses = fetchRetrieveExpenses();
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
                  InkWell(
                      onTap: () async {
                        var token = await UserPreferences.getToken();
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  const Text(
                    "Express",
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
                        color: fkBlueText,
                      ))
                ],
              )
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Total Expenses Amount",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceTiny,
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<RetrieveExpensesTotal>(
                future: retrieveExpensesTotal,
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  if (snapshot.hasData) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data!.currencyCode}",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: fkGreyText),
                        ),
                        Text(
                          "${snapshot.data!.totalAmount}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: fkBlackText),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                            child: Text(
                          snapshot.error != null
                              ? "Failed to load data"
                              : "Amount not available...",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: fkGreyText),
                        )));
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
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: fkDefaultColor,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_right_alt,
                        size: 28,
                        color: fkWhiteText,
                      ),
                      onPressed: () =>
                          PagesGenerator.goTo(context, name: "expense-options"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        verticalSpaceRegular,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Expenses saved list",
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
      ]),
      Expanded(
        child: FutureBuilder(
          future: retrieveExpenses,
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
                      return GestureDetector(
                        onLongPress: () {
                          screenTitle(context,
                              screenTitle:
                                  "${snapshot.data?[index].expenseName}");
                          PagesGenerator.goTo(context,
                              name: "update-expense-name",
                              params: {
                                "id": "${snapshot.data?[index].expenseId}"
                              });
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 0.0),
                            child: InkWell(
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.list_alt_outlined),
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
                                  trailing: Text(
                                    "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: fkBlueText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
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
                            )),
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
