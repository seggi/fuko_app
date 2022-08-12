import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/default_data.dart';
import 'package:fuko_app/core/dept.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:intl/intl.dart';

class BorrowerDeptList extends StatefulWidget {
  final String id;
  const BorrowerDeptList({Key? key, required this.id}) : super(key: key);

  @override
  State<BorrowerDeptList> createState() => _BorrowerDeptListState();
}

class _BorrowerDeptListState extends State<BorrowerDeptList> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<RetrieveDept>> retrieveBorrowerDeptList;
  late Future<RetrieveDept> retrieveBorrowerTotalAmount;

  late Future<List<RetrieveDept>> retrieveBorrowerPaymentHistory;
  late Future<RetrieveDept> retrieveBorrowerTotalPaidAmount;

  @override
  void initState() {
    super.initState();
    retrieveBorrowerDeptList =
        fetchBorrowerDept(borrowerId: widget.id, currencyCode: defaultCurrency);
    retrieveBorrowerTotalAmount = fetchTotalDeptAmount(
        borrowerId: widget.id, currencyCode: defaultCurrency);

    retrieveBorrowerPaymentHistory = fetchBorrowerPaymentHistory(
        noteId: widget.id, currencyCode: defaultCurrency);
    retrieveBorrowerTotalPaidAmount =
        fetchTotalPaidAmount(noteId: widget.id, currencyCode: defaultCurrency);
  }

  @override
  Widget build(BuildContext context) {
    final deptCategoryId = widget.id;
    FkManageProviders.save["save-borrower-id"](context, itemData: widget.id);
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveBorrowerDeptList = fetchBorrowerDept(
          borrowerId: deptCategoryId, currencyCode: setCurrency);
      retrieveBorrowerTotalAmount = fetchTotalDeptAmount(
          borrowerId: deptCategoryId, currencyCode: setCurrency);
    });

    return FkTabBarView.tabBar(context, addDeptFn: () {
      PagesGenerator.goTo(context,
          name: "save-dept", params: {"id": deptCategoryId});
    }, payDeptFn: () {
      PagesGenerator.goTo(
        context,
        name: "pay-private-dept",
        params: {"id": deptCategoryId},
      );
    }, screenTitle: screenTitle, pageTitle: const [
      Tab(child: Text("Dept")),
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
        FutureBuilder<RetrieveDept>(
          future: retrieveBorrowerTotalAmount,
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
                        "${double.parse(snapshot.data!.totalDept)}",
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
          future: retrieveBorrowerDeptList,
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
      retrieveBorrowerPaymentHistory = fetchBorrowerPaymentHistory(
          noteId: widget.id, currencyCode: setCurrency);
      retrieveBorrowerTotalPaidAmount =
          fetchTotalPaidAmount(noteId: widget.id, currencyCode: setCurrency);
    });
    return Column(
      children: [
        fkContentBoxWidgets.initialItems(itemList: [
          verticalSpaceRegular,
          const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Total Amount",
              style: TextStyle(
                  color: fkBlackText,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ),
          FutureBuilder<RetrieveDept>(
            future: retrieveBorrowerTotalPaidAmount,
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
            future: retrieveBorrowerPaymentHistory,
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
