import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/drop_down_box.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class SammaryScreen extends StatefulWidget {
  const SammaryScreen({Key? key}) : super(key: key);

  @override
  _SammaryScreenState createState() => _SammaryScreenState();
}

class _SammaryScreenState extends State<SammaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [CustomDropDownBox()],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: RichText(
              text: TextSpan(
                text: 'Sammary on Expenses for',
                style: TextStyle(fontSize: 18, color: fkBlackText),
                children: const <TextSpan>[
                  TextSpan(
                      text: ' 2021',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
          ),
          verticalSpaceRegular,
          summaryYearReport(month: "January", currency: "Rwf", amount: "2000"),
          Divider(
            thickness: 1,
          ),
          summaryYearReport(month: "February", currency: "Rwf", amount: "1800")
        ],
      ),
    );
  }

  Widget summaryYearReport({month, currency, amount}) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$month",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue),
          ),
          verticalSpaceSmall,
          Row(
            children: [
              Text(
                "$currency",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: fkGreyText),
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                "$amount",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 30,
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
