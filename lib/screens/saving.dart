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
  const SavingPage({Key? key}) : super(key: key);

  @override
  _SavingPageState createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<RetrieveSavingTotal> retrieveSavingTotal;
  late Future<List<RetrieveSaving>> retrieveSaving;

  @override
  void initState() {
    super.initState();
    retrieveSavingTotal = fetchRetrieveSavingTotal();
    retrieveSaving = fetchRetrieveSaving();
  }

  @override
  Widget build(BuildContext context) {
    return FkContentBoxWidgets.body(context, 'savings', fn: () {
      PagesGenerator.goTo(context, name: "register-saving");
    }, itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () async {
                    PagesGenerator.goTo(context, pathName: "/");
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications))
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Saving",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w600, color: fkBlackText),
          ),
        ),
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Total Saving Amount in the current month",
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
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Rwf",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: fkGreyText),
                          ),
                          Text(
                            "${snapshot.data!.totalAmount}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                                color: fkGreyText),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                              child: Text(
                            snapshot.error != null
                                ? "Failed to load data"
                                : "Amount not available...",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: fkGreyText),
                          )));
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
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: fkBlueText,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_right_alt,
                          size: 30,
                          color: fkWhiteText,
                        ),
                        onPressed: () {},
                        // onPressed: () => PagesGenerator.goTo(context,
                        //     name: "saving-options"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        verticalSpaceTiny,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Total amounts for this February",
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
      ]),
      Expanded(
        child: FutureBuilder(
          future: retrieveSaving,
          builder: (context, AsyncSnapshot<List<RetrieveSaving>> snapshot) {
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
                        child: reportCard(
                            monthText: toBeginningOfSentenceCase(
                                months[dateTime.month - 1]),
                            leadingText: "${dateTime.day}",
                            currency: "Rwf",
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
      ),
    ]);
  }
}
