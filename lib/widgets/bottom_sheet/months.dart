import 'package:flutter/material.dart';
import 'package:fuko_app/core/months_data.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../../controllers/manage_provider.dart';
import '../../core/currency_data.dart';
import '../../utils/constant.dart';

class MonthsButtonSheet extends StatefulWidget {
  const MonthsButtonSheet({Key? key}) : super(key: key);

  @override
  State<MonthsButtonSheet> createState() => _MonthsButtonSheetState();
}

class _MonthsButtonSheetState extends State<MonthsButtonSheet> {
  String searchString = " ";

  @override
  void initState() {
    super.initState();
    retrieveCurrencies = fetchCurrencies();
    retrieveMonths = fetchMonthsList();
  }

  @override
  Widget build(BuildContext context) {
    final setMonthNumber = FkManageProviders.save["add-selected-month"];
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                children: [
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Months",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Expanded(
                    child: FutureBuilder(
                      future: retrieveMonths,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot snapshot,
                      ) {
                        if (snapshot.hasData) {
                          if (snapshot.data.isEmpty) {
                            return Container(
                                margin: const EdgeInsets.only(top: 0.0),
                                child: const Center(
                                    child: Text("No data found!")));
                          }
                          return SizedBox(
                            child: NotificationListener<
                                OverscrollIndicatorNotification>(
                              onNotification: (OverscrollIndicatorNotification?
                                  overscroll) {
                                overscroll!.disallowIndicator();
                                return true;
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin: const EdgeInsets.only(top: 0.0),
                                      child: Card(
                                        child: ListTile(
                                          leading: const Icon(Icons.date_range),
                                          title: Text(
                                              "${snapshot.data?[index].name}"),
                                          onTap: () {
                                            setMonthNumber(context,
                                                monthNumber: snapshot
                                                    .data?[index]!.number);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ));
                                },
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong:('));
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
              );
            });
      },
      icon: const Icon(
        Icons.calendar_month,
        size: 20,
        color: fkWhiteText,
      ),
    );
  }
}
