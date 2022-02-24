import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();
  @override
  Widget build(BuildContext context) {
    return FkContentBoxWidgets.body(context, "budget", fn: () {}, itemList: [
      Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () =>
                    PagesGenerator.goTo(context, pathName: "/home"),
                icon: const Icon(Icons.arrow_back_ios)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Badge(
                  badgeContent: const Text(
                    '3',
                    style: TextStyle(color: fkWhiteText),
                  ),
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.notifications)),
                  position: BadgePosition.topEnd(end: 2, top: 2),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
            )
          ],
        ),
      ),
      fkContentBoxWidgets.initialItems(itemList: [
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Budget",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w600, color: fkBlackText),
          ),
        ),
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "List of budgets",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceTiny,
      ])
    ]);
  }
}
