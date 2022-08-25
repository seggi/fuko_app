import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/budget.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class BudgetDetails extends StatefulWidget {
  final String title;
  const BudgetDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  late Future<List<BudgetData>> retrieveBudgetEnvelop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveBudgetEnvelop =
        fetchBudgetEnvelope(currencyCode: defaultCurrency.toString());
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.save["save-screen-title"];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveBudgetEnvelop = fetchBudgetEnvelope(currencyCode: setCurrency);
    });

    return FkScrollViewWidgets.body(context, itemList: [
      Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          ),
                          onPressed: () => PagesGenerator.goTo(context,
                              pathName: "/budget")),
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            screenTitle(context, screenTitle: widget.title);
                            PagesGenerator.goTo(
                              context,
                              name: "add-budget-details",
                            );
                          },
                          icon: const Icon(
                            Icons.add_circle,
                            color: fkBlueText,
                          ))
                    ],
                  )
                ],
              ),
            ),
            verticalSpaceSmall,
            const Divider(
              color: fkGreyText,
            ),
            //

            Expanded(
              child: FutureBuilder(
                future: retrieveBudgetEnvelop,
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isEmpty) {
                      return Container(
                          margin: const EdgeInsets.only(top: 0.0),
                          child:
                              const Center(child: Text("No budget to show!")));
                    }
                    return SizedBox(
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification? overscroll) {
                          overscroll!.disallowIndicator();
                          return true;
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 12.0,
                                    right: 8.0,
                                    bottom: 12.0),
                                decoration: BoxDecoration(
                                  color: fkBlueLight,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${snapshot.data?[index].budgetCategory}"),
                                    Column(children: [
                                      Text(
                                          "${snapshot.data?[index].amountInitial}"),
                                      verticalSpaceTiny,
                                      Text(
                                          "${snapshot.data?[index].amountConsumed}")
                                    ])
                                  ],
                                ),
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong:('));
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
