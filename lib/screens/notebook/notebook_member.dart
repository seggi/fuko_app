import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class NotebookMember extends StatefulWidget {
  final String id;
  const NotebookMember({Key? key, required this.id}) : super(key: key);

  @override
  State<NotebookMember> createState() => _NotebookMemberState();
}

class _NotebookMemberState extends State<NotebookMember> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notebookId = widget.id;
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];

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
                        PagesGenerator.goTo(context, pathName: "notebook");
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  Text(
                    screenTitle,
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
                        Icons.person_add_alt,
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
            "All members",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceRegular,
        InkWell(
          onTap: () => PagesGenerator.goTo(context, name: "groupe-detail"),
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
