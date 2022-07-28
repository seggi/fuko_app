import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/dept.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

Widget homeCard({leadingIcon, currency, amount, titleTxt, fn}) {
  return InkWell(
    onTap: fn,
    child: Card(
      elevation: 0.0,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: fkGreyText, width: 0.5))),
        child: Column(
          children: [
            verticalSpaceTiny,
            ListTile(
              leading: Icon(
                leadingIcon,
                color: fkDefaultColor,
              ),
              subtitle: Row(
                children: [
                  Text(currency,
                      style: const TextStyle(
                          color: fkGreyText,
                          fontWeight: FontWeight.w300,
                          fontSize: 11)),
                  horizontalSpaceTiny,
                  Text(amount,
                      style: const TextStyle(
                          color: fkGreyText,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                ],
              ),
              title: Text(titleTxt,
                  style: const TextStyle(
                      color: fkBlackText,
                      fontWeight: FontWeight.w400,
                      fontSize: 18)),
            ),
          ],
        ),
      ),
    ),
  );
}

// Report card

Widget reportCard(context,
    {deptId,
    monthText,
    leadingText,
    currency,
    amount,
    titleTxt,
    currencyCode,
    borrowerId,
    String? bdTxt,
    fn}) {
  return ReportCard(
      borrowerId: borrowerId,
      currencyCode: currencyCode,
      deptId: deptId,
      monthText: monthText,
      leadingText: leadingText,
      currency: currency,
      amount: amount,
      titleTxt: titleTxt);
}

class ReportCard extends StatefulWidget {
  final String? deptId;
  final String? bdTxt;
  final String? leadingText;
  final String? amount;
  final String? currency;
  final String? titleTxt;
  final String? currencyCode;
  final String? monthText;
  final String? borrowerId;

  const ReportCard(
      {Key? key,
      this.deptId,
      this.bdTxt,
      this.monthText,
      this.leadingText,
      this.currency,
      this.amount,
      this.titleTxt,
      this.borrowerId,
      this.currencyCode})
      : super(key: key);

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  late Future<ReportCardTotal> retrieveReportCardTotal;
  late Future<List<ReportCardData>> retrieveReportCardData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveReportCardTotal = fetchReportCardTotal();
    retrieveReportCardData = fetchReportCardData();
  }

  @override
  Widget build(BuildContext context) {
    final deptId = widget.deptId;
    final bdTxt = widget.bdTxt;
    final monthText = widget.monthText;
    final leadingText = widget.leadingText;
    final currency = widget.currency;
    final amount = widget.amount;
    final titleTxt = widget.titleTxt;
    final currencyCode = widget.currencyCode;
    final borrowerId = widget.borrowerId;

    return Card(
      child: ExpansionTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8.0),
            color: fkBlueText,
            child: FittedBox(
              child: Column(
                children: [
                  Text(
                    monthText!,
                    style: const TextStyle(fontSize: 15, color: fkWhiteText),
                  ),
                  Text(leadingText!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 24))
                ],
              ),
            ),
          ),
        ),
        subtitle: Row(
          children: [
            Text(currency!,
                style: const TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w300,
                    fontSize: 11)),
            horizontalSpaceTiny,
            Text(amount!,
                style: const TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
          ],
        ),
        title: Text(titleTxt!,
            style: const TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 18)),
        controlAffinity: ListTileControlAffinity.leading,
        trailing: const Icon(Icons.arrow_drop_down),
        children: <Widget>[
          const Divider(
            height: 1,
          ),
          FutureBuilder<ReportCardTotal>(
              future: fetchReportCardTotal(
                  deptId: deptId, currencyCode: currencyCode),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    color: fkBlueLight,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Total Paid",
                                style: TextStyle(fontWeight: FontWeight.w400)),
                            Text("${snapshot.data!.paidAmount}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold))
                          ],
                        ),
                        InkWell(
                          onTap: snapshot.data!.paymentStatus != true
                              ? () => PagesGenerator.goTo(context,
                                      name: "dept-payment",
                                      params: {
                                        "id": "$deptId",
                                      })
                              : () {},
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(238, 129, 0, 0),
                                borderRadius: BorderRadius.circular(4.0)),
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.payments_sharp,
                                  color: fkWhiteText,
                                ),
                                horizontalSpaceTiny,
                                Text(
                                  "Pay",
                                  style: TextStyle(
                                      color: fkWhiteText,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(child: Text("DDD"));
                }
              }),
          verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                // const Text(
                //   "Description",
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  children: const [
                    Text(
                      "Date",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<ReportCardData>>(
                future: fetchReportCardData(
                    deptId: deptId, currencyCode: currencyCode),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var dateTime = DateTime.parse(
                              "${snapshot.data?[index].createdAt}");
                          return Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${snapshot.data?[index].amount}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                  // SizedBox(
                                  //   width: 200,
                                  //   child: Text(
                                  //     "${snapshot.data?[index].description}",
                                  //     style: const TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w500,
                                  //     ),
                                  //   ),
                                  // ),
                                  // const Divider(
                                  //   thickness: 1,
                                  // ),
                                  Text(
                                    "${dateTime.year}-${dateTime.month}-${dateTime.day}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpaceSmall
                            ],
                          );
                        });
                    // } else {
                    //   return const SizedBox(
                    //     child: Center(
                    //       child: Text("No data to show currently."),
                    //     ),
                    //   );
                    // }
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong :('));
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.black,
                    ),
                  );
                }),
          ),
          verticalSpaceSmall,
        ],
      ),
    );
  }
}
