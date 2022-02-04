import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/custom_btn.dart';
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [customTextButton(btnTxt: "Year")],
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Febuary",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: fkBlackText),
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        Text(
                          "Rwf",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: fkGreyText),
                        ),
                        Text(
                          "450,000",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              color: fkGreyText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "June",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: fkBlackText),
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        Text(
                          "Rwf",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: fkGreyText),
                        ),
                        Text(
                          "30,000",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              color: fkGreyText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
