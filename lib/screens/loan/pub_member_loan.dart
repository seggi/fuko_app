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

class PubMemberLoanNotebookSheet extends StatefulWidget {
  const PubMemberLoanNotebookSheet({Key? key}) : super(key: key);

  @override
  State<PubMemberLoanNotebookSheet> createState() =>
      _PubMemberLoanNotebookSheetState();
}

class _PubMemberLoanNotebookSheetState
    extends State<PubMemberLoanNotebookSheet> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<RetrieveBorrowersList> retrieveDeptAmount;
  late Future<List<LoanList>> retrieveLenderList;

  @override
  void initState() {
    super.initState();
    retrieveDeptAmount = fetchDeptAmount(setCurrency: defaultCurrency);
    retrieveLenderList = fetchMemberFromLoanNotebook();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.save["save-screen-title"];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveDeptAmount = fetchDeptAmount(setCurrency: setCurrency);
      retrieveLenderList = fetchMemberFromLoanNotebook();
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
                FutureBuilder<RetrieveBorrowersList>(
                  future: retrieveDeptAmount,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot snapshot,
                  ) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [],
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
                  "Loan notebook member",
                  style: TextStyle(
                      color: fkBlackText,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      retrieveDeptAmount =
                          fetchDeptAmount(setCurrency: setCurrency);
                      retrieveLenderList = fetchMemberFromLoanNotebook();
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
            future: retrieveLenderList,
            builder: (context, AsyncSnapshot<List<LoanList>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No data to show.'),
                  );
                }
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
                              "${snapshot.data?[index].username}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          subtitle: SizedBox(
                            width: 200,
                            child: Text(
                              "${snapshot.data?[index].lastName} ${snapshot.data?[index].firstName}",
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
                            screenTitle: "${snapshot.data?[index].username}");
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
