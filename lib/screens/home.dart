import 'package:flutter/material.dart';
import 'package:fuko_app/core/user_preferences.dart';

import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class HomePage extends StatefulWidget {
  final Map data;
  const HomePage({Key? key, required this.data}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: FkContentBoxWidgets.body(context, 'home', itemList: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.notifications)),
                  IconButton(
                      onPressed: () {
                        UserPreferences.removeToken();
                        Navigator.pushReplacementNamed(context, "/");
                      },
                      icon: const Icon(Icons.logout))
                ],
              )),
          fkContentBoxWidgets.initialItems(
            itemList: <Widget>[
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Marugira Seggi",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: fkBlackText),
                ),
              ),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Your current wallet amount is",
                  style: TextStyle(
                      color: fkGreyText,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            "Rwf",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: fkGreyText),
                          ),
                          Text(
                            "500,000",
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
                        child: const Icon(
                          Icons.account_balance_wallet,
                          size: 24,
                          color: fkGreyText,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          FkContentBoxWidgets.buttonsItemsBox(context, itemList: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Total amounts on each operation",
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            ),
            verticalSpaceTiny,
            // Saving Screen
            homeCard(
                leadingIcon: Icons.calculate,
                currency: "Rwf",
                amount: "105,000",
                titleTxt: "Expenses",
                fn: () {
                  Navigator.of(context).pushNamed('/expenses');
                }),
            verticalSpaceTiny,
            homeCard(
                leadingIcon: Icons.savings,
                currency: "Rwf",
                amount: "10,000",
                titleTxt: "Savings",
                fn: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ExpensesPage()));
                }),
            verticalSpaceTiny,
            homeCard(
                leadingIcon: Icons.account_balance,
                currency: "Rwf",
                amount: "30,500",
                titleTxt: "Loan",
                fn: () {}),
            verticalSpaceTiny,
            homeCard(
                leadingIcon: Icons.money_off,
                currency: "Rwf",
                amount: "105,000",
                titleTxt: "Depts",
                fn: () {}),
            verticalSpaceTiny,
            homeCard(
                leadingIcon: Icons.schedule_outlined,
                currency: "Rwf",
                amount: "535 000",
                titleTxt: "Budget",
                fn: () {}),
            verticalSpaceMedium,
          ])
        ]));
  }
}
