import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
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

  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomDropDownBox(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                ],
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: const TextSpan(
                        text: 'Total Amount',
                        style: TextStyle(
                            fontSize: 18,
                            color: fkBlackText,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        "Rwf",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: fkGreyText),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "10,500",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: fkBlackText),
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpaceSmall,
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
