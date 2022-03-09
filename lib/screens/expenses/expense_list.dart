import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/expenses.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<RetrieveDetailsExpenses>> retrieveExpensesTotal;

  @override
  void initState() {
    super.initState();
    retrieveExpensesTotal = fetchRetrieveDetailsExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FkContentBoxWidgets.body(context, 'savings', fn: () {
      PagesGenerator.goTo(context, name: "save-expenses");
    }, itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () async {
                    PagesGenerator.goTo(context, pathName: "/expenses");
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        verticalSpaceTiny,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Expenses saved list",
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
      ]),
      Expanded(
        child: FutureBuilder(
          future: retrieveExpensesTotal,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
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
                          child: InkWell(
                            child: Card(
                              child: ListTile(
                                leading: const Icon(Icons.list_alt_outlined),
                                title: SizedBox(
                                  width: 200,
                                  child: Text(
                                    snapshot.data?[index].expenseName ??
                                        "No title provided }",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                trailing: Text(
                                  "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: fkBlueText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () => PagesGenerator.goTo(context,
                                name: "expense-list"),
                          ));
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
