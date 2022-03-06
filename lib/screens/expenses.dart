import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/default_data.dart';
import 'package:fuko_app/core/expenses.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
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
    if (widget.status == "true") {
      setState(() {
        retrieveExpensesTotal = fetchRetrieveExpensesTotal();
        retrieveExpenses = fetchRetrieveExpenses();
      });
    }
    return FkContentBoxWidgets.body(context, 'savings', fn: () {
      PagesGenerator.goTo(context, name: "save-expenses");
    }, itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () async {
                    var token = await UserPreferences.getToken();
                    PagesGenerator.goTo(context, pathName: "/?status=true");
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications))
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Expenses",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w600, color: fkBlackText),
          ),
        ),
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Total Expenses Amount in the current month",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceTiny,
        Card(
          elevation: 8.0,
          color: fkDefaultColor,
          child: Container(
            height: 100,
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          const Text(
                            "Rwf",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: fkGreyText),
                          ),
                          Text(
                            "${snapshot.data!.totalAmount}",
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
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: fkBlueText,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_right_alt,
                          size: 30,
                          color: fkWhiteText,
                        ),
                        onPressed: () => PagesGenerator.goTo(context,
                            name: "expense-options"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        verticalSpaceTiny,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Total amounts for this Febuary",
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

                      return Container(
                        margin: const EdgeInsets.only(top: 0.0),
                        child: reportCard(
                            monthText: toBeginningOfSentenceCase(
                                months[dateTime.month - 1]),
                            leadingText: "${dateTime.day}",
                            currency: "Rwf",
                            amount: snapshot.data?[index].amount,
                            titleTxt: snapshot.data?[index].title != ""
                                ? "${snapshot.data?[index].title}"
                                : "${snapshot.data?[index].description}",
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
