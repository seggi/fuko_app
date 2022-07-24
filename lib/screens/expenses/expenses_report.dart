import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/expense_report.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/years.dart';
import 'package:fuko_app/widgets/drop_down_box.dart';
import 'package:fuko_app/widgets/shared/style.dart';

import '../../widgets/expanded_listtile.dart';
import '../../widgets/shared/ui_helper.dart';

class ExpenseReport extends StatefulWidget {
  const ExpenseReport({Key? key}) : super(key: key);

  @override
  State<ExpenseReport> createState() => _ExpenseReportState();
}

class _ExpenseReportState extends State<ExpenseReport> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<MonthlyTotalAmount> retrieveMonthlyTotalAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveMonthlyTotalAmount =
        fetchMonthlyTotalAmount(currencyCode: defaultCurrency.toString());
  }

  @override
  Widget build(BuildContext context) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var getStatus = FkManageProviders.get(context)["get-status"];
    // final updateStatus = FkManageProviders.save["update-status"];
    var getCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    var getSelectedYear = FkManageProviders.get(context)["get-selected-year"];
    var year = getSelectedYear != '' ? getSelectedYear : currentYear;

    if (getStatus == "true") {
      setState(() {
        retrieveMonthlyTotalAmount = fetchMonthlyTotalAmount(
            currencyCode: getCurrency, selectedYear: year);
      });
    }

    return FkContentBoxWidgets.body(context, 'savings list',
        fn: () {},
        itemList: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () async {
                          PagesGenerator.goTo(context, pathName: "/expenses");
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        )),
                    const Text(
                      "Report",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          return Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.warning,
                                  color: Colors.orange,
                                ),
                                horizontalSpaceSmall,
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Text(
                                      "No data to show in this year ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        }
                      })
                ],
              ),
              verticalSpaceRegular,
              Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: const TextSpan(
                    text: 'Details on all Expenses',
                    style: TextStyle(fontSize: 16, color: fkBlackText),
                  ),
                ),
              ),
              verticalSpaceSmall,
            ],
          ),
          expenseDetails()
        ]);
  }

  Widget expenseDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomExpandedListTile(
                data: const {
                  "month": "January",
                  "currency": "Rwf",
                  "totalAmount": "2500",
                  "date": "02",
                  "amount": "2000",
                  "description": "Achat 4 sacs du Riz & 2 d'huiles"
                },
              ),
              verticalSpaceTiny,
              CustomExpandedListTile(
                data: const {
                  "month": "June",
                  "currency": "Rwf",
                  "totalAmount": "5000",
                  "date": "12",
                  "amount": "4400",
                  "description": "By electricity & pay House rent"
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
