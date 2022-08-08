import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/dept.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class ListAllDept extends StatefulWidget {
  final String? id;
  const ListAllDept({Key? key, this.id}) : super(key: key);

  @override
  State<ListAllDept> createState() => _ListAllDeptState();
}

class _ListAllDeptState extends State<ListAllDept> {
  String searchString = " ";
  List<bool> selectedBtn = [false, false];
  late Future<List<RetrieveDept>> retrieveBorrowerPaymentHistory;
  late Future<RetrieveDept> retrieveBorrowerTotalPaidAmount;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  get scaffoldMessenger => null;

  @override
  void initState() {
    super.initState();
    retrieveBorrowerPaymentHistory = fetchBorrowerPaymentHistory(
        noteId: widget.id, currencyCode: defaultCurrency);
    retrieveBorrowerTotalPaidAmount =
        fetchTotalPaidAmount(noteId: widget.id, currencyCode: defaultCurrency);
  }

  @override
  Widget build(BuildContext context) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveBorrowerPaymentHistory = fetchBorrowerPaymentHistory(
          noteId: widget.id, currencyCode: setCurrency);
      retrieveBorrowerTotalPaidAmount =
          fetchTotalPaidAmount(noteId: widget.id, currencyCode: setCurrency);
    });

    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Column(
                  children: [
                    verticalSpaceSmall,
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Payment history",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        verticalSpaceRegular,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Total Amount",
                                  style: TextStyle(
                                      color: fkBlackText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                              verticalSpaceRegular,
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "0.0",
                                  style: TextStyle(
                                      color: fkBlackText,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: retrieveBorrowerPaymentHistory,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.isEmpty) {
                                return Container(
                                    margin: const EdgeInsets.only(top: 0.0),
                                    child: const Center(
                                        child: Text("No amount saved yet!")));
                              }
                              return NotificationListener<
                                  OverscrollIndicatorNotification>(
                                onNotification:
                                    (OverscrollIndicatorNotification?
                                        overscroll) {
                                  overscroll!.disallowIndicator();
                                  return true;
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      key: UniqueKey(),
                                      child: ListTile(
                                        selected: false,
                                        onTap: () {
                                          setState(() {});
                                        },
                                        title: Text(snapshot
                                                    .data?[index].description !=
                                                "null"
                                            ? "${snapshot.data?[index].description}"
                                            : "No description"),
                                        subtitle: Text(
                                          snapshot.data?[index].amount,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Something went wrong :('));
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            );
                          },
                        ),
                      ]),
                    )
                  ],
                ),
              );
            });
      },
      icon: const Icon(
        Icons.payments,
        size: 20,
        color: fkBlueText,
      ),
    );
  }
}
