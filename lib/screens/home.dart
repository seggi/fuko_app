import 'package:flutter/material.dart';
import 'package:fuko_app/core/notebook.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/global_amount.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/provider/authentication.dart';

import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:go_router/go_router.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class HomePage extends StatefulWidget {
  final String? status;

  const HomePage({Key? key, required this.status}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<GlobalAmount> globalAmount;
  late Future<List<Notebook>> retrieveIncomingRequest;

  @override
  void initState() {
    super.initState();
    globalAmount = fetchGlobalTotalDeptAndLoanAmount(
        currencyId: defaultCurrency.toString());
    retrieveIncomingRequest = fetchIncomingRequest(context);
  }

  @override
  Widget build(BuildContext context) {
    final userData = FkManageProviders.get(context)["auth"][0];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var getCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      globalAmount = fetchGlobalTotalDeptAndLoanAmount(currencyId: getCurrency);
    });

    return Container(
      color: fkDefaultColor,
      child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: RefreshIndicator(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox.fromSize(
                  size: MediaQuery.of(context).size,
                  child: customFutureBuilder(userData)),
            ),
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  globalAmount = fetchGlobalTotalDeptAndLoanAmount(
                      currencyId: getCurrency);
                  retrieveIncomingRequest = fetchIncomingRequest(context);
                });

                // ignore: deprecated_member_use
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Page Refreshed'),
                  ),
                );
              });
            },
          )),
    );
  }

  Widget customFutureBuilder(userData) {
    final badgeTxt = FkManageProviders.get(context)['get-request-number'];
    return FutureBuilder<GlobalAmount>(
      future: globalAmount,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return FkContentBoxWidgets.body(context, 'home',
                badgeTxt: badgeTxt,
                fn: () =>
                    PagesGenerator.goTo(context, pathName: "/notification"),
                username:
                    "${toBeginningOfSentenceCase("${userData['data']["username"]}")}",
                picture: "${userData['data']["picture"]}",
                itemList: [
                  FkContentBoxWidgets.buttonsItemsBox(context, itemList: [
                    verticalSpaceMedium,
                    // Saving Screen
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: fkWhiteText,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.0),
                                          ),
                                        ),
                                        child: const Icon(Icons.dashboard),
                                      ),
                                      onTap: () => context.go('/dashboard'),
                                    ),
                                    verticalSpaceSmall,
                                    const Text(
                                      "Dashboard",
                                      style: TextStyle(
                                          color: fkWhiteText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: fkWhiteText,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.0),
                                          ),
                                        ),
                                        child: const Icon(Icons.group),
                                      ),
                                      onTap: () => context.go('/groupe'),
                                    ),
                                    verticalSpaceSmall,
                                    const Text(
                                      "Groupe",
                                      style: TextStyle(
                                          color: fkWhiteText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: fkWhiteText,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30.0),
                                          ),
                                        ),
                                        child: const Icon(Icons.note_add),
                                      ),
                                      onTap: () => context.go('/notebook'),
                                    ),
                                    verticalSpaceSmall,
                                    const Text(
                                      "Notebook",
                                      style: TextStyle(
                                          color: fkWhiteText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),

                    verticalSpaceMedium,
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          homeCard(
                              leadingIcon: Icons.calculate,
                              currency: snapshot.data!.currencyCode,
                              amount: moneyFormat(
                                  amount: snapshot.data!.totalExpenses),
                              titleTxt: "Expenses",
                              fn: () => context.go('/expenses')),
                          verticalSpaceTiny,
                          homeCard(
                              leadingIcon: Icons.savings,
                              currency: snapshot.data!.currencyCode,
                              amount: moneyFormat(
                                  amount: snapshot.data!.totalSavings),
                              titleTxt: "Savings",
                              fn: () => context.go('/saving')),
                          verticalSpaceTiny,
                          homeCard(
                              leadingIcon: Icons.account_balance,
                              currency: snapshot.data!.currencyCode,
                              amount:
                                  moneyFormat(amount: snapshot.data!.totalLoan),
                              titleTxt: "Loan",
                              fn: () => context.go('/loan')),
                          verticalSpaceTiny,
                          homeCard(
                              leadingIcon: Icons.money_off,
                              currency: snapshot.data!.currencyCode,
                              amount:
                                  moneyFormat(amount: snapshot.data!.totalDept),
                              titleTxt: "Dept",
                              fn: () => context.go('/dept')),
                          verticalSpaceTiny,
                          homeCard(
                              leadingIcon: Icons.schedule_outlined,
                              currency: "",
                              amount: "",
                              titleTxt: "Budget",
                              fn: () => PagesGenerator.goTo(context,
                                  pathName: "/budget")),
                          verticalSpaceMedium,
                        ],
                      ),
                    ),
                  ])
                ]);
          } else {
            return FkContentBoxWidgets.body(context, 'home', itemList: [
              Container(
                  padding: const EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                      child: Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            UserPreferences.removeToken();
                            context.read<AuthenticationData>().logout();
                            context.go('/');
                          },
                          icon: const Icon(
                            Icons.logout_outlined,
                            color: fkWhiteText,
                          )),
                      const Text(
                        "Please click here to logout",
                        style: TextStyle(color: fkWhiteText),
                      )
                    ],
                  )))
            ]);
          }
        }

        return FkContentBoxWidgets.body(context, 'home', itemList: [
          Expanded(
              child: Container(
            color: fkDefaultColor,
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: fkWhiteText,
                      ),
                    ),
                    horizontalSpaceRegular,
                    Text(
                      "Loading info...",
                      style: TextStyle(color: fkWhiteText),
                    )
                  ],
                ),
              ),
            ),
          ))
        ]);
      },
    );
  }
}
