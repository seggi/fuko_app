import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuko_app/controllers/manage_provider.dart';

import '../../controllers/page_generator.dart';
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
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];
    return Container(
        child: FkContentBoxWidgets.body(context, 'groupe detail', itemList: [
      Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        PagesGenerator.goTo(context, pathName: "/groupe");
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                    Text(
                      "$screenTitle",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                      ),
                    ),
                    IconButton(
                      onPressed: () => PagesGenerator.goTo(context,
                          name: "invite-friend-to-group"),
                      icon: const Icon(
                        FontAwesomeIcons.paperPlane,
                        color: fkBlueText,
                        size: 18,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
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
                            fontSize: 24,
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
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: fkGreyText, width: 0.5))),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: fkGreyText,
                    child: Icon(
                      Icons.person,
                      color: fkWhiteText,
                    ),
                  ),
                  title: const Text("Seggi SMS"),
                  subtitle: const Text("Paid for Ingredients"),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "2235",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                      verticalSpaceTiny,
                      Text(
                        "Borrowed",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Colors.red),
                      )
                    ],
                  ),
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
