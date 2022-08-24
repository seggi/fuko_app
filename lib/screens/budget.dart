import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/budget.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';

import 'budget/budget_card.dart';

class BudgetScreen extends StatefulWidget {
  final String? status;
  const BudgetScreen({Key? key, this.status}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<BudgetData>> retrieveBudgetList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveBudgetList = fetchBudgetList();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      retrieveBudgetList = fetchBudgetList();
    });

    return FkContentBoxWidgets.body(context, "budget", fn: () {
      PagesGenerator.goTo(
        context,
        name: "register-budget",
      );
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
                      PagesGenerator.goTo(context, pathName: "/?status=true");
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    )),
                const Text(
                  "Budget",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
            )
          ],
        ),
      ),
      FutureBuilder(
        future: retrieveBudgetList,
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 200),
                child: const Center(
                  child: Text('No budget save yet.'),
                ),
              );
            }
            return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var dateTime =
                          DateTime.parse("${snapshot.data?[index].createdAt}");

                      return Column(
                        children: [
                          BudgetBoxCard(
                            createdAt:
                                "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                            title: "${snapshot.data?[index].title}",
                            fn: () => PagesGenerator.goTo(context,
                                name: "budget-detail",
                                params: {
                                  "title": "${snapshot.data?[index].title}"
                                }),
                          ),
                        ],
                      );
                    }));
          } else if (snapshot.hasError) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text(
                      snapshot.error != null
                          ? "Failed to load data"
                          : "Not data available...",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: fkGreyText),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
              padding: const EdgeInsets.all(20.0),
              child: const Center(
                  child: Text(
                "Loading budget...",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: fkGreyText),
              )));
        },
      ),
    ]);
  }
}
