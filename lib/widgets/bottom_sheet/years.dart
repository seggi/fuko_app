import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuko_app/core/months_data.dart';
import 'package:fuko_app/core/years.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:http/http.dart' as http;

import '../../controllers/manage_provider.dart';
import '../../core/currency_data.dart';
import '../../core/expenses.dart';
import '../../core/user_preferences.dart';
import '../../utils/api.dart';
import '../../utils/constant.dart';

// ignore: must_be_immutable
class YearButtonSheet extends StatefulWidget {
  const YearButtonSheet({Key? key}) : super(key: key);

  @override
  State<YearButtonSheet> createState() => _YearButtonSheetState();
}

class _YearButtonSheetState extends State<YearButtonSheet> {
  late Future<List<GetYears>> retrieveYears;

  @override
  void initState() {
    super.initState();
    retrieveYears = fetchYears();
  }

  @override
  Widget build(BuildContext context) {
    final updateStatus = FkManageProviders.save["update-status"];
    final saveSelectedYear = FkManageProviders.save["add-selected-year"];

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
                          "Years",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Expanded(
                    child: FutureBuilder(
                      future: retrieveYears,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot snapshot,
                      ) {
                        if (snapshot.hasData) {
                          if (snapshot.data.isEmpty) {
                            return Container(
                                margin: const EdgeInsets.only(top: 0.0),
                                child: const Center(
                                    child: Text("No expense saved yet!")));
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
                                          leading:
                                              const Icon(Icons.calendar_month),
                                          title: Text(
                                              "${snapshot.data?[index].year}"),
                                          onTap: () {
                                            saveSelectedYear(context,
                                                year:
                                                    snapshot.data?[index].year);

                                            updateStatus(context,
                                                status: "true");

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
        color: fkBlackText,
      ),
    );
  }
}
