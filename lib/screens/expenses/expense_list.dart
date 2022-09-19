import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/default_data.dart';
import 'package:fuko_app/core/expenses.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:intl/intl.dart';

import '../../utils/constant.dart';

class ExpenseList extends StatefulWidget {
  final String id;
  const ExpenseList({Key? key, required this.id}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    final screenTitle = FkManageProviders.get(context)['get-screen-title'];

    return FkContentBoxWidgets.body(context, 'savings', fn: () {
      PagesGenerator.goTo(context,
          name: "save-expenses", params: {"id": widget.id});
    }, itemList: [
      Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      PagesGenerator.goTo(context, pathName: "/expenses");
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    )),
                Text(
                  screenTitle,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
      fkContentBoxWidgets.initialItems(itemList: [
        verticalSpaceRegular,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Total Amount",
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
        verticalSpaceTiny,
        FutureBuilder<RetrieveDetailsExpensesListByDate>(
          future: fetchDetailsExpensesTotalAmountByDate(
              expenseId: widget.id, currencyId: setCurrency),
          builder: (
            BuildContext context,
            AsyncSnapshot snapshot,
          ) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${double.parse(snapshot.data!.totalAmount)}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: fkBlackText),
                      ),
                    ],
                  ),
                  snapshot.data!.currencyCode != ""
                      ? Container(
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
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container()
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
                      color: fkBlackText),
                )));
          },
        ),
      ]),
      Expanded(
        child: FutureBuilder(
          future: fetchExpensesDetailList(
              expenseId: widget.id, currencyId: setCurrency),
          builder: (
            BuildContext context,
            AsyncSnapshot snapshot,
          ) {
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
                        child: reportCard(context,
                            monthText: toBeginningOfSentenceCase(
                                months[dateTime.month - 1]),
                            leadingText: "${dateTime.day}",
                            currency: "",
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
              return const Center(child: Text('Something went wrong 😟'));
            }
            return const SizedBox();
          },
        ),
      ),
    ]);
  }
}
