import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/dept.dart';
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
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<LoanList> retrieveLoanAmount;
  late Future<List<LoanList>> retrievePrivateLoanList;

  @override
  void initState() {
    super.initState();
    retrieveLoanAmount = fetchLoanAmount(setCurrency: defaultCurrency);
    retrievePrivateLoanList = fetchPrivateLoanList();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.save["save-screen-title"];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveLoanAmount = fetchLoanAmount(setCurrency: setCurrency);
      retrievePrivateLoanList = fetchPrivateLoanList();
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
                FutureBuilder<LoanList>(
                  future: retrieveLoanAmount,
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
                                  "${double.parse(snapshot.data!.totalLoan)}",
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
                      retrieveLoanAmount =
                          fetchLoanAmount(setCurrency: setCurrency);
                      retrievePrivateLoanList = fetchPrivateLoanList();
                    });
                  },
                  child: const Icon(Icons.refresh))
            ],
          ),
          verticalSpaceSmall,
        ]),
        SizedBox(
          // height: MediaQuery.of(context).size.height - 290,
          child: FutureBuilder(
            future: retrievePrivateLoanList,
            builder: (context, AsyncSnapshot<List<LoanList>> snapshot) {
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
                    return InkWell(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.account_circle_outlined,
                            size: 30,
                          ),
                          title: SizedBox(
                            width: 200,
                            child: Text(
                              snapshot.data?[index].lenderName != null
                                  ? "${snapshot.data?[index].lenderName != "null" ? snapshot.data![index].lenderName : 'No name provided'}"
                                  : "${snapshot.data?[index].firstName != null}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        screenTitle(context,
                            screenTitle: "${snapshot.data?[index].lenderName}");
                        PagesGenerator.goTo(context,
                            name: "lender-loan-details",
                            params: {"id": "${snapshot.data?[index].id}"});
                      },
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
