import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/default_data.dart';
import 'package:fuko_app/core/expenses.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatefulWidget {
  final String id;
  const ExpenseList({Key? key, required this.id}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<RetrieveDetailsExpenses>> retrieveExpensesList;
  late Future<RetrieveDetailsExpensesListByDate> retrieveExpensesTotal;

  @override
  void initState() {
    super.initState();
    retrieveExpensesList = fetchDetailsExpensesListByDate(expenseId: widget.id);
    retrieveExpensesTotal =
        fetchDetailsExpensesTotalAmountByDate(expenseId: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];
    return FkContentBoxWidgets.body(context, 'savings list', fn: () {
      PagesGenerator.goTo(context,
          name: "save-expenses", params: {"id": widget.id});
    }, itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () async {
                    PagesGenerator.goTo(context, pathName: "/expenses");
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            screenTitle,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.w600, color: fkBlackText),
          ),
        ),
        verticalSpaceTiny,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Total Amount",
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
        FutureBuilder<RetrieveDetailsExpensesListByDate>(
          future: retrieveExpensesTotal,
          builder: (
            BuildContext context,
            AsyncSnapshot snapshot,
          ) {
            if (snapshot.hasData) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rwf",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: fkGreyText),
                  ),
                  Text(
                    "${double.parse(snapshot.data!.totalAmount)}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        color: fkGreyText),
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
      ]),
      Expanded(
        child: FutureBuilder(
          future: fetchDetailsExpensesListByDate(expenseId: widget.id),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    child: const Center(child: Text("No expense saved yet!")));
              }
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

                      return Container(
                        margin: const EdgeInsets.only(top: 0.0),
                        child: reportCard(
                            monthText: toBeginningOfSentenceCase(
                                months[dateTime.month - 1]),
                            leadingText: "${dateTime.day}",
                            currency: "Rwf",
                            amount: snapshot.data?[index].amount,
                            titleTxt: snapshot.data?[index].description ??
                                "No description",
                            bdTxt: snapshot.data?[index].description,
                            fn: () {}),
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
