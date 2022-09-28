import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/dept.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class PubMemberDeptNotebookSheet extends StatefulWidget {
  const PubMemberDeptNotebookSheet({Key? key}) : super(key: key);

  @override
  State<PubMemberDeptNotebookSheet> createState() =>
      _PubMemberDeptNotebookSheetState();
}

class _PubMemberDeptNotebookSheetState
    extends State<PubMemberDeptNotebookSheet> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

// RetrieveBorrowersList

  late Future<RetrieveBorrowersList> retrieveDeptAmount;
  late Future<List<RetrieveBorrowersList>> retrieveBorrowerList;

  @override
  void initState() {
    super.initState();
    retrieveDeptAmount = fetchDeptAmount(setCurrency: defaultCurrency);
    retrieveBorrowerList = fetchMemberFromDeptNotebook();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final screenTitle = FkManageProviders.save["save-screen-title"];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveDeptAmount = fetchDeptAmount(setCurrency: setCurrency);
      retrieveBorrowerList = fetchMemberFromDeptNotebook();
    });

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
                  fkContentBoxWidgets.initialItems(itemList: [
                    verticalSpaceSmall,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [],
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
                                      )),
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
                                  child: const Center());
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Dept notebook member",
                            style: TextStyle(
                                color: fkBlackText,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceTiny,
                  ]),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 290,
                    child: FutureBuilder(
                      future: retrieveBorrowerList,
                      builder: (context,
                          AsyncSnapshot<List<RetrieveBorrowersList>> snapshot) {
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
                                                      "loanMembership":
                                                          "${snapshot.data?[index].loanMembership}"
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
                                                    "loanMembership":
                                                        "${snapshot.data?[index].loanMembership}"
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
                                      )),
                                ),
                                onTap: () {
                                  screenTitle(context,
                                      screenTitle:
                                          "${snapshot.data?[index].username}");
                                  FkManageProviders
                                      .remove['remove-amount-saved'](context);
                                  PagesGenerator.goTo(context,
                                      name: "borrower_dept_details",
                                      params: {
                                        "id":
                                            "${snapshot.data?[index].borrowerId}",
                                        "loanMembership":
                                            "${snapshot.data?[index].loanMembership}"
                                      });
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong :('));
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
              ),
            ),
          ),
        ),
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              retrieveDeptAmount =
                  fetchDeptAmount(setCurrency: defaultCurrency);
              retrieveBorrowerList = fetchMemberFromDeptNotebook();
            });

            // ignore: deprecated_member_use
            _scaffoldKey.currentState!.showSnackBar(
              const SnackBar(
                content: Text('Page Refreshed'),
              ),
            );
          });
        },
      ),
    );
  }
}
