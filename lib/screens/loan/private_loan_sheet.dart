import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/loan.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class PrivateLoanSheet extends StatefulWidget {
  const PrivateLoanSheet({Key? key}) : super(key: key);

  @override
  State<PrivateLoanSheet> createState() => _PrivateLoanSheetState();
}

class _PrivateLoanSheetState extends State<PrivateLoanSheet> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<LoanList> retrieveLoanAmount;
  late Future<List<LoanList>> retrievePrivateLoanList;

  @override
  void initState() {
    retrieveLoanAmount = fetchLoanAmount(setCurrency: defaultCurrency);
    retrievePrivateLoanList = fetchPrivateLoanList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final screenTitle = FkManageProviders.save["save-screen-title"];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();
    final saveLoanData = FkManageProviders.save["save-select-item"];

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: RefreshIndicator(
          backgroundColor: fkWhiteText,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox.fromSize(
                size: MediaQuery.of(context).size,
                child: SizedBox(
                  height: height,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      fkContentBoxWidgets.initialItems(
                        itemList: [
                          verticalSpaceRegular,
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FutureBuilder<LoanList>(
                                  future: retrieveLoanAmount,
                                  builder: (
                                    BuildContext context,
                                    AsyncSnapshot snapshot,
                                  ) {
                                    if (snapshot.hasData) {
                                      return Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  moneyFormat(
                                                      amount: snapshot
                                                          .data!.totalLoan),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: fkBlackText),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                child: Container(
                                                  color: fkDefaultColor,
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Text(
                                                          "${snapshot.data!.currencyCode ?? ''}",
                                                          style: const TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  fkWhiteText),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                child: Container(
                                                  color: fkDefaultColor,
                                                  child: Row(
                                                    children: const [
                                                      CurrencyButtonSheet()
                                                    ],
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
                                      child: const Center(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          verticalSpaceSmall,
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: retrievePrivateLoanList,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<LoanList>> snapshot) {
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

                                  return Slidable(
                                    startActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                            flex: 2,
                                            icon: Icons.update,
                                            label: "Update name",
                                            backgroundColor: updateBtnColor,
                                            onPressed: ((context) {
                                              saveLoanData(context, itemData: {
                                                "id":
                                                    "${snapshot.data?[index].id}",
                                                "lender_name":
                                                    "${snapshot.data?[index].lenderName != "null" ? snapshot.data![index].lenderName : 'No name provided'}"
                                              });
                                              PagesGenerator.goTo(context,
                                                  name: "update-loan");
                                            }))
                                      ],
                                    ),
                                    child: Card(
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.account_circle_outlined,
                                          size: 30,
                                        ),
                                        title: SizedBox(
                                          width: 200,
                                          child: Text(
                                            snapshot.data?[index].lenderName !=
                                                    null
                                                ? "${snapshot.data?[index].lenderName != "null" ? snapshot.data![index].lenderName : 'No name provided'}"
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
                                                      name: "save-loan",
                                                      params: {
                                                        "id":
                                                            "${snapshot.data?[index].id}",
                                                        "deptMemberShip":
                                                            memberShipId
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
                                                    name: "pay-private-loan",
                                                    params: {
                                                      "id":
                                                          "${snapshot.data?[index].id}",
                                                      "deptMemberShip":
                                                          memberShipId
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
                                                  "${snapshot.data![index].lenderName}");
                                          FkManageProviders.remove[
                                              'remove-amount-saved'](context);
                                          PagesGenerator.goTo(context,
                                              name: "lender-loan-details",
                                              params: {
                                                "id":
                                                    "${snapshot.data?[index].id}",
                                                "deptMemberShip": memberShipId
                                              });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Something went wrong :('));
                            }

                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 50.0),
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
                  ),
                )),
          ),
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                retrieveLoanAmount = fetchLoanAmount(setCurrency: setCurrency);
                retrievePrivateLoanList = fetchPrivateLoanList();
              });

              // ignore: deprecated_member_use
              _scaffoldKey.currentState!.showSnackBar(
                const SnackBar(
                  content: Text('Page Refreshed'),
                ),
              );
            });
          },
        ));
  }
}
