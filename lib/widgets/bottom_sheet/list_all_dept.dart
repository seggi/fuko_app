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
  late Future<List<RetrieveDept>> retrieveBorrowerDeptList;
  late Future<RetrieveDept> retrieveBorrowerTotalAmount;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  get scaffoldMessenger => null;

  // Future<List<RetrieveDetailsExpenses>> getExpenseByMonth() async {
  //   var token = await UserPreferences.getToken();
  //   var expenseData = {"year": 2022, "month": 8, "currency_id": 150};
  //   final response = await http.post(
  //       Uri.parse(Network.getExpensesDetailsByMonth + "/8"),
  //       headers: Network.authorizedHeaders(token: token),
  //       body: jsonEncode(expenseData));

  //   if (response.statusCode == 200) {
  //     var expensesData =
  //         jsonDecode(response.body)["data"]["expenses_list"] as List;

  //     setState(() {
  //       retrieveExpensesDetailListByMonth = expensesData;
  //     });

  //     return expensesData
  //         .map((expense) => RetrieveDetailsExpenses.fromJson(expense))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load data');
  //   }

  // }

  @override
  void initState() {
    super.initState();
    retrieveBorrowerDeptList =
        fetchBorrowerDept(borrowerId: widget.id, currencyCode: defaultCurrency);
    retrieveBorrowerTotalAmount = fetchTotalDeptAmount(
        borrowerId: widget.id, currencyCode: defaultCurrency);
  }

  @override
  Widget build(BuildContext context) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveBorrowerDeptList =
          fetchBorrowerDept(borrowerId: widget.id, currencyCode: setCurrency);
      retrieveBorrowerTotalAmount = fetchTotalDeptAmount(
          borrowerId: widget.id, currencyCode: setCurrency);
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
                        "All Dept",
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
                          future: retrieveBorrowerDeptList,
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
                                    // return Container(
                                    //   margin: const EdgeInsets.only(top: 0.0),
                                    //   child: reportCard(context,
                                    //       paymentStatus:
                                    //           "${snapshot.data?[index].paymentStatus}",
                                    //       borrowerId: widget.id,
                                    //       deptId: snapshot.data?[index].deptId,
                                    //       currencyCode: setCurrency,
                                    //       monthText: toBeginningOfSentenceCase(
                                    //           months[dateTime.month - 1]),
                                    //       leadingText: "${dateTime.day}",
                                    //       currency: "",
                                    //       amount: snapshot.data?[index].amount,
                                    //       titleTxt:
                                    //           snapshot.data?[index].description != "null"
                                    //               ? "${snapshot.data?[index].description}"
                                    //               : "No description",
                                    //       fn: () {}),
                                    // );
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
