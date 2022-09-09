import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/expense_report.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/years.dart';
import 'package:fuko_app/widgets/shared/style.dart';

import '../../widgets/expanded/expanded_listtile.dart';
import '../../widgets/shared/ui_helper.dart';

class ExpenseReport extends StatefulWidget {
  const ExpenseReport({Key? key}) : super(key: key);

  @override
  State<ExpenseReport> createState() => _ExpenseReportState();
}

class _ExpenseReportState extends State<ExpenseReport> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<MonthlyTotalAmount> retrieveMonthlyTotalAmount;
  late Future<List<MonthlyReportDetail>> retrieveMonthlyReportDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveMonthlyTotalAmount =
        fetchMonthlyTotalAmount(currencyCode: defaultCurrency.toString());
    retrieveMonthlyReportDetail =
        fetchMonthlyReportDetail(currencyCode: defaultCurrency.toString());
  }

  @override
  Widget build(BuildContext context) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var getStatus = FkManageProviders.get(context)["get-status"];
    var getCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    var getSelectedYear = FkManageProviders.get(context)["get-selected-year"];
    var year = getSelectedYear != '' ? getSelectedYear : currentYear;

    if (getStatus == "true") {
      setState(() {
        retrieveMonthlyTotalAmount = fetchMonthlyTotalAmount(
            currencyCode: getCurrency, selectedYear: year);

        retrieveMonthlyReportDetail = fetchMonthlyReportDetail(
            currencyCode: getCurrency, selectedYear: year);
      });
    }

    return FkContentBoxWidgets.body(context, 'savings', fn: () {}, itemList: [
      Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
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
                const Text(
                  "Report",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
      fkContentBoxWidgets.initialItems(
        itemList: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Year $year",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: fkBlueText),
              ),
              const YearButtonSheet(),
            ],
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<MonthlyTotalAmount>(
                  future: retrieveMonthlyTotalAmount,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Text(
                            "${snapshot.data!.currencyCode}",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: fkGreyText),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "${snapshot.data!.totalAmount}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: fkBlackText),
                          ),
                        ],
                      );
                    } else {
                      return Expanded(child: Container());
                    }
                  })
            ],
          ),
          verticalSpaceSmall,
        ],
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<MonthlyReportDetail>>(
              future: retrieveMonthlyReportDetail,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            CustomExpandedListTile(
                              data: {
                                "month": "${snapshot.data[index].month}",
                                "currency": "",
                                "totalAmount":
                                    "${snapshot.data[index].totalAmount}",
                                "description":
                                    "Achat 4 sacs du Riz & 4 d'huiles",
                                "detailsData": snapshot.data[index]!.data
                              },
                            ),
                            verticalSpaceTiny,
                          ],
                        );
                      });
                } else {
                  return Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: const Text("Loading... ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ),
      )
    ]);
  }
}
