import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/default_data.dart';
import 'package:fuko_app/core/loan.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:intl/intl.dart';

class LenderLoanList extends StatefulWidget {
  final String id;
  const LenderLoanList({Key? key, required this.id}) : super(key: key);

  @override
  State<LenderLoanList> createState() => _LenderLoanListState();
}

class _LenderLoanListState extends State<LenderLoanList> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<LoanList>> retrieveLenderLoanList;
  late Future<LoanList> retrieveTotalAmount;

  late Future<List<LoanList>> retrievePaymentHistory;
  late Future<LoanList> retrieveTotalPaidAmount;

  @override
  void initState() {
    super.initState();
    retrieveLenderLoanList =
        fetchLenderLoan(lenderId: widget.id, currencyCode: defaultCurrency);
    retrieveTotalAmount = fetchTotalLoanAmount(
        lenderId: widget.id, currencyCode: defaultCurrency);

    retrievePaymentHistory =
        fetchPaymentHistory(noteId: widget.id, currencyCode: defaultCurrency);
    retrieveTotalPaidAmount = fetchTotalLenderPaidAmount(
        noteId: widget.id, currencyCode: defaultCurrency);
  }

  @override
  Widget build(BuildContext context) {
    final loanCategoryId = widget.id;
    FkManageProviders.save["save-lender-id"](context, itemData: widget.id);
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveLenderLoanList =
          fetchLenderLoan(lenderId: loanCategoryId, currencyCode: setCurrency);
      retrieveTotalAmount = fetchTotalLoanAmount(
          lenderId: loanCategoryId, currencyCode: setCurrency);
    });

    return FkTabBarView.tabBar(context, addFn: () {
      PagesGenerator.goTo(context,
          name: "save-loan", params: {"id": loanCategoryId});
    }, paymentFn: () {
      PagesGenerator.goTo(
        context,
        name: "pay-private-loan",
        params: {"id": loanCategoryId},
      );
    }, screenTitle: screenTitle, pageTitle: const [
      Tab(child: Text("Loan")),
      Tab(child: Text("Amount Paid"))
    ], page: [
      pageOne(),
      pageTwo()
    ]);
  }

  Widget pageOne() {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();
    return Column(mainAxisSize: MainAxisSize.min, children: [
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
        FutureBuilder<LoanList>(
          future: retrieveTotalAmount,
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
                        "${double.parse(snapshot.data!.totalLoan)}",
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
                      color: fkGreyText),
                )));
          },
        ),
      ]),
      SizedBox(
        height: MediaQuery.of(context).size.height - 220,
        child: FutureBuilder(
          future: retrieveLenderLoanList,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    child: const Center(child: Text("No amount saved yet!")));
              }
              return SizedBox(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification:
                      (OverscrollIndicatorNotification? overscroll) {
                    overscroll!.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var dateTime =
                          DateTime.parse("${snapshot.data?[index].createdAt}");

                      return Container(
                        margin: const EdgeInsets.only(top: 0.0),
                        child: reportCard(context,
                            currencyCode: setCurrency,
                            monthText: toBeginningOfSentenceCase(
                                months[dateTime.month - 1]),
                            leadingText: dateTime.day >= 10
                                ? "${dateTime.day}"
                                : "0${dateTime.day}",
                            amount: snapshot.data?[index].amount,
                            trailingText:
                                "From: ${snapshot.data?[index].username}",
                            titleTxt:
                                snapshot.data?[index].description != "null"
                                    ? "${snapshot.data?[index].description}"
                                    : "No description",
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

  Widget pageTwo() {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrievePaymentHistory =
          fetchPaymentHistory(noteId: widget.id, currencyCode: setCurrency);
      retrieveTotalPaidAmount = fetchTotalLenderPaidAmount(
          noteId: widget.id, currencyCode: setCurrency);
    });
    return Column(
      children: [
        fkContentBoxWidgets.initialItems(itemList: [
          verticalSpaceRegular,
          const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Total Amounts",
              style: TextStyle(
                  color: fkBlackText,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ),
          FutureBuilder<LoanList>(
            future: retrieveTotalPaidAmount,
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
                          "${double.parse(snapshot.data!.paidAmount)}",
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
                        color: fkGreyText),
                  )));
            },
          ),
        ]),
        SizedBox(
          height: MediaQuery.of(context).size.height - 220,
          child: FutureBuilder(
            future: retrievePaymentHistory,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isEmpty) {
                  return Container(
                      margin: const EdgeInsets.only(top: 0.0),
                      child: const Center(child: Text("No amount saved yet!")));
                }
                return NotificationListener<OverscrollIndicatorNotification>(
                  onNotification:
                      (OverscrollIndicatorNotification? overscroll) {
                    overscroll!.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var dateTime =
                          DateTime.parse("${snapshot.data?[index].createdAt}");

                      return Container(
                        margin: const EdgeInsets.only(top: 0.0),
                        child: reportCard(context,
                            currencyCode: setCurrency,
                            monthText: toBeginningOfSentenceCase(
                                months[dateTime.month - 1]),
                            leadingText: dateTime.day >= 10
                                ? "${dateTime.day}"
                                : "0${dateTime.day}",
                            amount: snapshot.data?[index].amount,
                            titleTxt:
                                snapshot.data?[index].description != "null"
                                    ? "${snapshot.data?[index].description}"
                                    : "No description",
                            fn: () {}),
                      );
                    },
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
        )
      ],
    );
  }
}
