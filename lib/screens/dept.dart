import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/dept.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:fuko_app/widgets/show_modal_bottom_sheet.dart';

class DeptPage extends StatefulWidget {
  final String? status;

  const DeptPage({Key? key, required this.status}) : super(key: key);

  @override
  _DeptPageState createState() => _DeptPageState();
}

class _DeptPageState extends State<DeptPage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

// RetrieveBorrowersList

  late Future<RetrieveBorrowersList> retrieveDeptAmount;
  late Future<List<RetrieveBorrowersList>> retrieveBorrowerList;

  @override
  void initState() {
    super.initState();
    retrieveDeptAmount = fetchDeptAmount(setCurrency: defaultCurrency);
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
      retrieveDeptAmount = fetchDeptAmount(setCurrency: setCurrency);
      retrieveBorrowerList = fetchBorrowerList();
    });

    return FkContentBoxWidgets.body(context, 'savings', itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () async {
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                  const Text(
                    "Dept",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () => customBottomModalSheet(context),
                      // PagesGenerator.goTo(context, name: "create-expense"),
                      icon: const Icon(
                        Icons.person_add_alt,
                        color: fkBlueText,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search_sharp,
                        color: fkBlueText,
                      ))
                ],
              )
            ],
          )),
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
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data!.currencyCode ?? ''}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: fkGreyText),
                              ),
                              Text(
                                "${snapshot.data!.totalDept}",
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
                                      padding: const EdgeInsets.all(8.0),
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
        verticalSpaceRegular,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Borrowers Recorded",
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
      ]),
      Expanded(
        child: FutureBuilder(
          future: retrieveBorrowerList,
          builder:
              (context, AsyncSnapshot<List<RetrieveBorrowersList>> snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification:
                      (OverscrollIndicatorNotification? overscroll) {
                    overscroll!.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No data to show.'),
                        );
                      }

                      return Container(
                          margin: const EdgeInsets.only(top: 0.0),
                          child: InkWell(
                            child: Card(
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
                              ),
                            ),
                            onTap: () {
                              screenTitle(context,
                                  screenTitle:
                                      "${snapshot.data?[index].borrowerName}");
                              PagesGenerator.goTo(context,
                                  name: "borrower_dept_details",
                                  params: {
                                    "id": "${snapshot.data?[index].borrowerId}"
                                  });
                            },
                          ));
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong :('));
            }
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      ),
    ]);
  }
}
