import 'package:flutter/material.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../controllers/page_generator.dart';
import '../widgets/shared/style.dart';
import 'content_box_widgets.dart';

class GroupePage extends StatefulWidget {
  const GroupePage({Key? key}) : super(key: key);

  @override
  State<GroupePage> createState() => _GroupePageState();
}

class _GroupePageState extends State<GroupePage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FkContentBoxWidgets.body(context, 'groupe', itemList: [
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
                    "Groupe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () =>
                          PagesGenerator.goTo(context, name: "create-groupe"),
                      icon: const Icon(
                        Icons.add_circle,
                        color: fkBlueText,
                      ))
                ],
              )
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        verticalSpaceMedium,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "All groupes",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceRegular,
        InkWell(
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: fkGreyText, width: 0.5))),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: fkGreyText,
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                horizontalSpaceSmall,
                const Text("Test")
              ],
            ),
          ),
        )
      ])
    ]));
  }
}
