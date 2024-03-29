import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/dept.dart';
import 'package:fuko_app/core/global_amount.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class PrivateDeptSheet extends StatefulWidget {
  const PrivateDeptSheet({Key? key}) : super(key: key);

  @override
  State<PrivateDeptSheet> createState() => _PrivateDeptSheetState();
}

class _PrivateDeptSheetState extends State<PrivateDeptSheet> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

// RetrieveBorrowersList

  late Future<GlobalAmount> retrieveGlobalTotalDeptAndLoanAmount;
  late Future<List<RetrieveBorrowersList>> retrieveBorrowerList;

  @override
  void initState() {
    super.initState();
    retrieveGlobalTotalDeptAndLoanAmount = fetchGlobalTotalDeptAndLoanAmount(
        currencyId: defaultCurrency.toString());
    retrieveBorrowerList = fetchBorrowerList();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.save["save-screen-title"];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveGlobalTotalDeptAndLoanAmount =
          fetchGlobalTotalDeptAndLoanAmount(currencyId: setCurrency);
      retrieveBorrowerList = fetchBorrowerList();
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        fkContentBoxWidgets.initialItems(itemList: [
          verticalSpaceRegular,
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<GlobalAmount>(
                  future: retrieveGlobalTotalDeptAndLoanAmount,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot snapshot,
                  ) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  moneyFormat(amount: snapshot.data!.totalDept),
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
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Text(
                                          "${snapshot.data!.currencyCode ?? ''}",
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
                        ),
                      );
                    }
                    return Container(
                        padding: const EdgeInsets.all(20.0),
                        child: const Center());
                  },
                ),
              ],
            ),
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Recorded info",
                  style: TextStyle(
                      color: fkBlackText,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      retrieveGlobalTotalDeptAndLoanAmount =
                          fetchGlobalTotalDeptAndLoanAmount(
                              currencyId: setCurrency);
                      retrieveBorrowerList = fetchBorrowerList();
                    });
                  },
                  child: const Icon(Icons.refresh))
            ],
          ),
          verticalSpaceSmall,
        ]),
        SizedBox(
          height: MediaQuery.of(context).size.height - 290,
          child: FutureBuilder(
            future: retrieveBorrowerList,
            builder:
                (context, AsyncSnapshot<List<RetrieveBorrowersList>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No data to show.'),
                      );
                    }
                    return Card(
                      child: Slidable(
                        startActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                                flex: 2,
                                icon: Icons.update,
                                label: "Update name",
                                backgroundColor: updateBtnColor,
                                onPressed: ((context) {}))
                          ],
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.account_circle_outlined,
                            size: 30,
                          ),
                          title: SizedBox(
                            width: 200,
                            child: Text(
                              snapshot.data?[index].borrowerName != null
                                  ? "${snapshot.data?[index].borrowerName != "null" ? snapshot.data![index].borrowerName : 'No name provided'}"
                                  : "${snapshot.data?[index].firstName != null}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    PagesGenerator.goTo(context,
                                        name: "save-dept",
                                        params: {
                                          "id":
                                              "${snapshot.data?[index].borrowerId}",
                                          "loanMembership": memberShipId
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.post_add,
                                    color: fkBlackText,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    PagesGenerator.goTo(
                                      context,
                                      name: "pay-private-dept",
                                      params: {
                                        "id":
                                            "${snapshot.data?[index].borrowerId}",
                                        "loanMembership": memberShipId
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.payments_outlined,
                                    color: fkBlackText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            screenTitle(context,
                                screenTitle:
                                    "${snapshot.data?[index].borrowerName}");
                            FkManageProviders
                                .remove['remove-amount-saved'](context);
                            PagesGenerator.goTo(context,
                                name: "borrower_dept_details",
                                params: {
                                  "id": "${snapshot.data?[index].borrowerId}",
                                  "loanMembership": memberShipId
                                });
                          },
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong :('));
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
