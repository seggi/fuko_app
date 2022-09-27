import 'package:flutter/material.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/screens/dashboard/chart.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:money_formatter/money_formatter.dart';

import '../controllers/manage_provider.dart';
import '../controllers/page_generator.dart';
import '../core/global_amount.dart';
import '../core/user_preferences.dart';
import '../widgets/shared/style.dart';
import '../widgets/shared/ui_helper.dart';

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
    globalAmount = fetchGlobalTotalDeptAndLoanAmount(
        currencyId: defaultCurrency.toString());
  }

  @override
  Widget build(BuildContext context) {
    final userData = FkManageProviders.get(context)["auth"][0];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      globalAmount = fetchGlobalTotalDeptAndLoanAmount(currencyId: setCurrency);
    });

    return Container(
      color: fkWhiteText,
      child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: RefreshIndicator(
            backgroundColor: fkWhiteText,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox.fromSize(
                  size: MediaQuery.of(context).size,
                  child: customFutureBuilder(userData)),
            ),
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  globalAmount = fetchGlobalTotalDeptAndLoanAmount();
                });

                // ignore: deprecated_member_use
                _scaffoldKey.currentState!.showSnackBar(
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
    return FutureBuilder<GlobalAmount>(
      future: globalAmount,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (snapshot.hasData) {
          MoneyFormatter totalAmount =
              MoneyFormatter(amount: double.parse(snapshot.data!.globalAmount));
          var totalExpense = double.parse(snapshot.data!.totalExpenses).toInt();
          var totalSavings = double.parse(snapshot.data!.totalSavings).toInt();
          var totalLoan = double.parse(snapshot.data!.totalLoan).toInt();
          var totalDept = double.parse(snapshot.data!.totalDept).toInt();

          return FkContentBoxWidgets.body(context, 'dashboard', itemList: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  const Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            verticalSpaceSmall,
            fkContentBoxWidgets.initialItems(
              itemList: <Widget>[
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Your current wallet amount is",
                    style: TextStyle(
                        color: fkDefaultColor,
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
                          Text(
                            snapshot.data!.currencyCode,
                            style: const TextStyle(
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
            verticalSpaceSmall,
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ChartReport(
                      expenses: '$totalExpense',
                      savings: '$totalSavings',
                      dept: '$totalDept',
                      loan: '$totalLoan'),
                ),
              ),
            )
          ]);
        } else {
          return FkContentBoxWidgets.body(context, 'dashboard', itemList: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        var token = await UserPreferences.getToken();
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  const Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height / 2,
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Please wait...",
                    )
                  ],
                )))
          ]);
        }
      },
    );
  }
}
