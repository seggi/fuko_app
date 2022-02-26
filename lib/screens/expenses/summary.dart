import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/drop_down_box.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [CustomDropDownBox()],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: const TextSpan(
                    text: 'Total Amount',
                    style: TextStyle(
                        fontSize: 18,
                        color: fkBlackText,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Row(
                children: const <Widget>[
                  Text(
                    "Rwf",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: fkGreyText),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "10,500",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: fkBlackText),
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceSmall,
          Align(
            alignment: Alignment.bottomLeft,
            child: RichText(
              text: const TextSpan(
                text: 'Summary on Expenses for',
                style: TextStyle(fontSize: 16, color: fkGreyText),
                children: <TextSpan>[
                  TextSpan(
                      text: ' 2021',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: fkBlueText)),
                ],
              ),
            ),
          ),
          verticalSpaceRegular,
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                summaryYearReport(
                    month: "January", currency: "Rwf", amount: "2500"),
                const Divider(
                  thickness: 1,
                ),
                summaryYearReport(
                    month: "June", currency: "Rwf", amount: "5000"),
                const Divider(
                  thickness: 1,
                ),
                summaryYearReport(
                    month: "September", currency: "Rwf", amount: "1000"),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget summaryYearReport({month, currency, amount}) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.date_range),
              const SizedBox(
                width: 10,
              ),
              Text(
                "$month",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: fkBlueText),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "$currency",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: fkGreyText),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "$amount",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: fkBlackText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
