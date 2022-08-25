import 'package:flutter/material.dart';
import 'package:fuko_app/core/budget.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../../controllers/manage_provider.dart';
import '../../utils/constant.dart';

// ignore: must_be_immutable
class BudgetListSheet extends StatefulWidget {
  const BudgetListSheet({Key? key}) : super(key: key);

  @override
  State<BudgetListSheet> createState() => _BudgetListSheetState();
}

class _BudgetListSheetState extends State<BudgetListSheet> {
  get scaffoldMessenger => null;

  @override
  void initState() {
    super.initState();
    retrieveBudgetPeriod = fetchBudgetPeriod();
  }

  @override
  Widget build(BuildContext context) {
    final savePeriodSelected = FkManageProviders.save["add-selected-budget"];

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
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20.0),
                          child: Text(
                            "Periods",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    Expanded(
                      child: FutureBuilder(
                        future: retrieveBudgetPeriod,
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
                                onNotification:
                                    (OverscrollIndicatorNotification?
                                        overscroll) {
                                  overscroll!.disallowIndicator();
                                  return true;
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        margin: const EdgeInsets.only(top: 0.0),
                                        child: Card(
                                          child: ListTile(
                                            leading:
                                                const Icon(Icons.date_range),
                                            title: Text(
                                                "${snapshot.data?[index].budget}"),
                                            subtitle: Text(
                                                "${snapshot.data?[index].description}"),
                                            onTap: () {
                                              savePeriodSelected(context,
                                                  periods: {
                                                    'id':
                                                        "${snapshot.data?[index].id}",
                                                    "budget":
                                                        "${snapshot.data?[index].budget}"
                                                  });
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
          Icons.date_range,
        ));
  }
}
