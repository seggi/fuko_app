import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/default_data.dart';
import 'package:fuko_app/core/dept.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
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

  @override
  void initState() {
    super.initState();
    retrieveBorrowerDeptList = fetchBorrowerDept(borrowerId: widget.id);
    retrieveBorrowerTotalAmount = fetchTotalDeptAmount(borrowerId: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];
    return FkContentBoxWidgets.body(context, 'dept list', fn: () {
      PagesGenerator.goTo(context,
          name: "save-dept", params: {"id": widget.id});
    }, itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () async {
                    PagesGenerator.goTo(context, pathName: "/dept");
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
        FutureBuilder<RetrieveDept>(
          future: retrieveBorrowerTotalAmount,
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
                    "${double.parse(snapshot.data!.totalDeptAmount)}",
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
          future: fetchBorrowerDept(borrowerId: widget.id),
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
                        child: reportCard(context,
                            monthText: toBeginningOfSentenceCase(
                                months[dateTime.month - 1]),
                            leadingText: "${dateTime.day}",
                            currency: "Rwf",
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
}
