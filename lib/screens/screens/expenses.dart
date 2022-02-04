import 'package:flutter/material.dart';
import 'package:fuko_app/screens/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import 'expenses/expenses_details.dart';

class ExpensesPage extends StatefulWidget {
  ExpensesPage({Key? key}) : super(key: key);

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  FkContentBoxWidgets fkContentBoxWidgets = new FkContentBoxWidgets();
  @override
  Widget build(BuildContext context) {
    return FkContentBoxWidgets.body(context, 'savings', itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
            ],
          )),
      fkContentBoxWidgets.initialItems(
        itemList: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Expenses",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: fkBlackText),
            ),
          ),
          Align(
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
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rwf",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: fkGreyText),
                      ),
                      Text(
                        "10,000",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            color: fkGreyText),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: fkBlueText,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_right_alt,
                            size: 30,
                            color: fkWhiteText,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ExpenseOptionsScreen()));
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          verticalSpaceTiny,
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Total amounts for this Febuary",
              style: TextStyle(
                  color: fkBlackText,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ),
        ],
      ),
      FkContentBoxWidgets.buttonsItemsBox(context, itemList: [
        reportCard(
            leadingText: "01",
            currency: "Rwf",
            amount: "10,000",
            titleTxt: "Mafuta",
            bdTxt: "Mafuta ya OK",
            fn: () {}),
        verticalSpaceTiny,
        reportCard(
            leadingText: "02",
            currency: "Rwf",
            amount: "30,500",
            titleTxt: "Riz",
            bdTxt: "4 sacs du Riz",
            fn: () {}),
        verticalSpaceTiny,
        reportCard(
            leadingText: "03",
            currency: "Rwf",
            amount: "105,000",
            titleTxt: "L'eaux",
            fn: () {}),
        verticalSpaceTiny,
        reportCard(
            leadingText: "13",
            currency: "Rwf",
            amount: "56000",
            titleTxt: "Savons",
            fn: () {}),
        verticalSpaceMedium,
        reportCard(
            leadingText: "20",
            currency: "Rwf",
            amount: "35000",
            titleTxt: "Electricity",
            fn: () {}),
        verticalSpaceMedium,
      ])
    ]);
  }
}