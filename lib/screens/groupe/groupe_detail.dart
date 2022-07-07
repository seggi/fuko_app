import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../controllers/page_generator.dart';
import '../../core/user_preferences.dart';
import '../../widgets/draggable/custom_draggable_sheet.dart';
import '../../widgets/shared/style.dart';
import '../../widgets/shared/ui_helper.dart';
import '../content_box_widgets.dart';

class GroupDetail extends StatefulWidget {
  const GroupDetail({Key? key}) : super(key: key);

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FkContentBoxWidgets.body(context, 'groupe detail', itemList: [
      Column(
        children: [
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
                            PagesGenerator.goTo(context, pathName: "/groupe");
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          )),
                      const Text(
                        "Groupe Detail",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => PagesGenerator.goTo(context,
                              name: "create-groupe"),
                          icon: const Icon(
                            Icons.add_circle,
                            color: fkBlueText,
                          )),
                      IconButton(
                          onPressed: () => PagesGenerator.goTo(context,
                              name: "create-groupe"),
                          icon: const Icon(
                            Icons.repeat_on_rounded,
                            color: fkBlueText,
                          ))
                    ],
                  )
                ],
              )),
          fkContentBoxWidgets.initialItems(itemList: [
            verticalSpaceMedium,
            Container(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Rwf",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: fkBlackText),
                      ),
                      Text(
                        "3,456",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
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
            verticalSpaceRegular,
            InkWell(
              onTap: () => PagesGenerator.goTo(context, name: "groupe-detail"),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: fkGreyText, width: 0.5))),
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
                    Container(
                      width: 100,
                      height: 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [Text("Test"), Text("rwf 500")],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ])
        ],
      ),
      const CustomDraggableSheet()
    ]));
  }
}
