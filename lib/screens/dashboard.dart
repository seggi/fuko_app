import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/screens/dashboard/chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';

import '../controllers/manage_provider.dart';
import '../controllers/page_generator.dart';
import '../core/global_amount.dart';
import '../core/user_preferences.dart';
import '../provider/authentication.dart';
import '../widgets/shared/style.dart';
import '../widgets/shared/ui_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashBoardPage extends StatefulWidget {
  final String? status;
  const DashBoardPage({Key? key, required this.status}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
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
          MoneyFormatter totalAmount =
              MoneyFormatter(amount: double.parse(snapshot.data!.globalAmount));
          var totalExpense = double.parse(
                  snapshot.data!.globalAmountDetails['expenses'].toString())
              .toInt();
          var totalSavings = double.parse(
                  snapshot.data!.globalAmountDetails['savings'].toString())
              .toInt();
          var totalLoan = double.parse(
                  snapshot.data!.globalAmountDetails['loans'].toString())
              .toInt();
          var totalDept = double.parse(
                  snapshot.data!.globalAmountDetails['dept'].toString())
              .toInt();

          if (snapshot.hasData) {
            return FkContentBoxWidgets.body(context, 'dashboard', itemList: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () async {
                          var token = await UserPreferences.getToken();
                          PagesGenerator.goTo(context,
                              pathName: "/?status=true");
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        )),
                    const Text(
                      "Dashboard",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              verticalSpaceLarge,
              fkContentBoxWidgets.initialItems(
                itemList: <Widget>[
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
                  verticalSpaceRegular,
                  Container(
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0),
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
                                  color: fkBlackText),
                            ),
                            Text(
                              totalAmount.output.nonSymbol,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: fkBlackText),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 8.0),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 24,
                            color: fkBlackText,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpaceLarge,
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ChartReport(
                    expenses: '$totalExpense',
                    savings: '$totalSavings',
                    dept: '$totalDept',
                    loan: '$totalLoan'),
              )
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
          )),
          // ignore: prefer_const_constructors
        ]);
      },
    );
  }
}
