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
    paymentStatus,
    String? bdTxt,
    fn}) {
  return ReportCard(
      paymentStatus: paymentStatus,
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
  final String? paymentStatus;

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
      this.paymentStatus,
      this.currencyCode})
      : super(key: key);

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  @override
  Widget build(BuildContext context) {
    final monthText = widget.monthText;
    final leadingText = widget.leadingText;
    final amount = widget.amount;
    final titleTxt = widget.titleTxt;

    return Card(
      child: ListTile(
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
            Text(amount!,
                style: const TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18))
          ],
        ),
        title: Text(titleTxt!,
            style: const TextStyle(
                color: fkBlackText,
                overflow: TextOverflow.visible,
                fontWeight: FontWeight.w400,
                fontSize: 16)),
      ),
    );
  }
}
