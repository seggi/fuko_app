import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/global_amount.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:badges/badges.dart';
import 'package:fuko_app/provider/authentication.dart';

import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/other_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/src/provider.dart';

class HomePage extends StatefulWidget {
  final String? status;

  const HomePage({Key? key, required this.status}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<GlobalAmount> globalAmount;

  @override
  void initState() {
    super.initState();
    globalAmount = fetchGlobalAmount();
  }

  @override
  Widget build(BuildContext context) {
    final userData = FkManageProviders.get(context)["auth"][0];
    if (widget.status == "true") {
      setState(() {
        globalAmount = fetchGlobalAmount();
      });
    }

    return WillPopScope(
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
                globalAmount = fetchGlobalAmount();
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

  Widget customFutureBuilder(userData) {
    return FutureBuilder<GlobalAmount>(
      future: globalAmount,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            MoneyFormatter totalAmount = MoneyFormatter(
                amount: double.parse(snapshot.data!.globalAmount));
            MoneyFormatter totalExpense = MoneyFormatter(
                amount: double.parse(
                    snapshot.data!.globalAmountDetails['expenses'].toString()));
            MoneyFormatter totalSavings = MoneyFormatter(
                amount: double.parse(
                    snapshot.data!.globalAmountDetails['savings'].toString()));
            MoneyFormatter totalLoan = MoneyFormatter(
                amount: double.parse(
                    snapshot.data!.globalAmountDetails['loans'].toString()));
            MoneyFormatter totalDept = MoneyFormatter(
                amount: double.parse(
                    snapshot.data!.globalAmountDetails['dept'].toString()));

            return FkContentBoxWidgets.body(context, 'home', itemList: [
              Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.menu)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Badge(
                            badgeContent: const Text(
                              '9',
                              style: TextStyle(color: fkWhiteText),
                            ),
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.notifications)),
                            position: BadgePosition.topEnd(end: 2, top: 2),
                          ),
                          IconButton(
                              onPressed: () {
                                UserPreferences.removeToken();
                                context.read<AuthenticationData>().logout();
                                context.go('/');
                              },
                              icon: const Icon(Icons.logout)),
                        ],
                      )
                    ],
                  )),
              fkContentBoxWidgets.initialItems(
                itemList: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "${toBeginningOfSentenceCase("${userData['data']["username"]}")}",
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: fkBlackText),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Your current wallet amount is",
                      style: TextStyle(
                          color: fkGreyText,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
                  verticalSpaceTiny,
                  Card(
                    elevation: 8.0,
                    color: fkDefaultColor,
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Rwf",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: fkGreyText),
                              ),
                              Text(
                                totalAmount.output.nonSymbol,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: fkGreyText),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.account_balance_wallet,
                              size: 24,
                              color: fkGreyText,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              FkContentBoxWidgets.buttonsItemsBox(context, itemList: [
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Total amounts on each operation",
                    style: TextStyle(
                        color: fkGreyText,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                verticalSpaceTiny,
                // Saving Screen
                homeCard(
                    leadingIcon: Icons.calculate,
                    currency: "Rwf",
                    amount: totalExpense.output.nonSymbol,
                    titleTxt: "Expenses",
                    fn: () => context.go('/expenses')),
                verticalSpaceTiny,
                homeCard(
                    leadingIcon: Icons.savings,
                    currency: "Rwf",
                    amount: totalSavings.output.nonSymbol,
                    titleTxt: "Savings",
                    fn: () => context.go('/saving')),
                verticalSpaceTiny,
                homeCard(
                    leadingIcon: Icons.account_balance,
                    currency: "Rwf",
                    amount: totalLoan.output.nonSymbol,
                    titleTxt: "Loan",
                    fn: () {}),
                verticalSpaceTiny,
                homeCard(
                    leadingIcon: Icons.money_off,
                    currency: "Rwf",
                    amount: totalDept.output.nonSymbol,
                    titleTxt: "Dept",
                    fn: () => context.go('/dept')),
                verticalSpaceTiny,
                homeCard(
                    leadingIcon: Icons.schedule_outlined,
                    currency: "",
                    amount: "",
                    titleTxt: "Budget",
                    fn: () =>
                        PagesGenerator.goTo(context, pathName: "/budget")),
                verticalSpaceMedium,
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
                          icon: const Icon(Icons.logout_outlined)),
                      const Text("Please click to logout")
                    ],
                  )))
            ]);
          }
        }

        return FkContentBoxWidgets.body(context, 'home', itemList: [
          Expanded(
              child: Container(
            color: Colors.grey[300],
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: fkWhiteText,
                    borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    ),
                    horizontalSpaceRegular,
                    Text("Loading info...")
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
