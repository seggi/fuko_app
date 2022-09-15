import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/default_data.dart';
import 'package:fuko_app/core/saving.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class SavingPage extends StatefulWidget {
  final String? status;
  const SavingPage({Key? key, required this.status}) : super(key: key);

  @override
  _SavingPageState createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<RetrieveSavingTotal> retrieveSavingTotal;
  late Future<List<RetrieveSaving>> retrieveSavings;

  @override
  void initState() {
    super.initState();
    retrieveSavingTotal =
        fetchRetrieveSavingTotal(setCurrency: defaultCurrency);
    retrieveSavings = fetchRetrieveSaving(setCurrency: defaultCurrency);
  }

  @override
  Widget build(BuildContext context) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveSavingTotal = fetchRetrieveSavingTotal(setCurrency: setCurrency);
      retrieveSavings = fetchRetrieveSaving(setCurrency: setCurrency);
    });

    return FkContentBoxWidgets.body(context, 'savings', fn: () {
      PagesGenerator.goTo(context, name: "register-saving");
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
                  "Savings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () =>
                        PagesGenerator.goTo(context, name: "register-saving"),
                    icon: const Icon(
                      Icons.add_circle,
                      color: fkBlackText,
                    )),
                IconButton(
                    onPressed: () =>
                        PagesGenerator.goTo(context, name: "saving-report"),
                    icon: const Icon(
                      Icons.manage_history,
                      color: fkBlackText,
                      size: 20,
                    )),
              ],
            )
          ],
        ),
      ),
      verticalSpaceRegular,
      fkContentBoxWidgets.initialItems(itemList: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<RetrieveSavingTotal>(
                future: retrieveSavingTotal,
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${double.parse(snapshot.data!.totalAmount)}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: fkBlackText),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Container(
                                color: fkDefaultColor,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${snapshot.data!.currencyCode}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: fkWhiteText),
                                      ),
                                    ),
                                    const CurrencyButtonSheet(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                            child: Text(
                          snapshot.error != null
                              ? "Failed to load data"
                              : "Amount not available...",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: fkGreyText),
                        )),
                        Container(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Container(
                              color: fkDefaultColor,
                              child: Row(
                                children: const [CurrencyButtonSheet()],
                              ),
                            ),
                          ),
                        )
                      ],
                    ));
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
            ],
          ),
        ),
        verticalSpaceTiny,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Current month savings",
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
      ]),
      FutureBuilder<List<RetrieveSaving>>(
        future: retrieveSavings,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    horizontalSpaceSmall,
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                          "There is no saving recorded yet in this month...",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                ),
              );
            }
            return SizedBox(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification? overscroll) {
                  overscroll!.disallowIndicator();
                  return true;
                },
                child: ListView.builder(
                  shrinkWrap: true,
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
                          currency: snapshot.data?[index].currencyCode,
                          amount: snapshot.data?[index].amount,
                          titleTxt: "${snapshot.data?[index].description}",
                          bdTxt: snapshot.data?[index].description,
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
    ]);
  }
}
