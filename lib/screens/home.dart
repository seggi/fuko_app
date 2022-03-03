import 'package:flutter/material.dart';
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
import 'package:provider/src/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    final userToken = FkManageProviders.get(context)['get-token'];

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: FutureBuilder<GlobalAmount>(
            future: globalAmount,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                                  icon: const Icon(Icons.logout))
                            ],
                          )
                        ],
                      )),
                  fkContentBoxWidgets.initialItems(
                    itemList: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "${userData['data']["first_name"]} ${userData['data']["last_name"]}",
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
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                    double.parse(snapshot.data!.globalAmount)
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 35,
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
                        amount:
                            "${double.parse(snapshot.data!.globalAmountDetails['expenses'].toString())}",
                        titleTxt: "Expenses",
                        fn: () => context.go('/expenses')),
                    verticalSpaceTiny,
                    homeCard(
                        leadingIcon: Icons.savings,
                        currency: "Rwf",
                        amount:
                            "${double.parse(snapshot.data!.globalAmountDetails['savings'].toString())}",
                        titleTxt: "Savings",
                        fn: () {}),
                    verticalSpaceTiny,
                    homeCard(
                        leadingIcon: Icons.account_balance,
                        currency: "Rwf",
                        amount:
                            "${double.parse(snapshot.data!.globalAmountDetails['loans'].toString())}",
                        titleTxt: "Loan",
                        fn: () {}),
                    verticalSpaceTiny,
                    homeCard(
                        leadingIcon: Icons.money_off,
                        currency: "Rwf",
                        amount:
                            "${double.parse(snapshot.data!.globalAmountDetails['dept'].toString())}",
                        titleTxt: "Dept",
                        fn: () {}),
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
              } else if (snapshot.hasError) {
                return FkContentBoxWidgets.body(context, 'home', itemList: [
                  Container(
                      padding: const EdgeInsets.all(20.0),
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(child: Text('${snapshot.error}')))
                ]);
              }

              return FkContentBoxWidgets.body(context, 'home', itemList: [
                Container(
                    padding: const EdgeInsets.all(20.0),
                    height: MediaQuery.of(context).size.height / 2,
                    child: const Center(child: CircularProgressIndicator()))
              ]);
            }));
  }
}
