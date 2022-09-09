import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/budget.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class BudgetEnvelopList extends StatefulWidget {
  final String? currencyCode;
  const BudgetEnvelopList({Key? key, this.currencyCode}) : super(key: key);

  @override
  State<BudgetEnvelopList> createState() => _BudgetEnvelopListState();
}

class _BudgetEnvelopListState extends State<BudgetEnvelopList> {
  String searchString = " ";

  late Future<List<BudgetData>> retrieveBudgetEnvelopeList;

  @override
  void initState() {
    super.initState();
    final currencyCode = widget.currencyCode;
    retrieveBudgetEnvelopeList = fetchBudgetEnvelopeList(
      currencyCode: currencyCode!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final setCurrencyId = FkManageProviders.save["add-default-currency"];
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
                          "Envelop list",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Expanded(
                    child: FutureBuilder(
                      future: retrieveBudgetEnvelopeList,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot snapshot,
                      ) {
                        if (snapshot.hasData) {
                          if (snapshot.data.isEmpty) {
                            return Container(
                                margin: const EdgeInsets.only(top: 0.0),
                                child: const Center(
                                    child: Text("No envelop found!")));
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
                                        child: CheckboxListTile(
                                          value:
                                              snapshot.data?[index].isSelected,
                                          title: Text(
                                              "${snapshot.data?[index].budgetCategory}"),
                                          subtitle: Text(snapshot
                                              .data?[index].amountInitial),
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              snapshot.data?[index].isSelected =
                                                  newValue!;
                                            });
                                            snapshot.data?[index].isSelected =
                                                false;
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
        Icons.receipt_long,
        color: fkBlueText,
      ),
    );
  }
}
