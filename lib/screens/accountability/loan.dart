import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/accountability/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class LoanPage extends StatefulWidget {
  final String? status;
  const LoanPage({Key? key, required this.status}) : super(key: key);

  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();
  @override
  Widget build(BuildContext context) {
    if (widget.status == "true") {
      setState(() {});
    }

    return FkContentBoxWidgets.body(context, 'loan', itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () async {
                        var token = await UserPreferences.getToken();
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  const Text(
                    "Loan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_sharp)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person_add_alt,
                        color: fkBlueText,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search_sharp,
                        color: fkBlueText,
                      ))
                ],
              )
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Total loan Amount",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceRegular,
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Rwf",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: fkGreyText),
                  ),
                  Text(
                    "2000",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: fkBlackText),
                  ),
                ],
              ),
            ],
          ),
        ),
        verticalSpaceSmall,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Partners",
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
      ])
    ]);
  }
}
