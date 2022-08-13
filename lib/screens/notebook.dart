import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/screens/notebook/pub_notebook_sheet.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class NotebookPage extends StatefulWidget {
  const NotebookPage({Key? key}) : super(key: key);

  @override
  State<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
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
                IconButton(
                    iconSize: 18,
                    onPressed: () async {
                      PagesGenerator.goTo(context, pathName: "/?status=true");
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    )),
                horizontalSpaceRegular,
                const Text(
                  "Notebook",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () =>
                        PagesGenerator.goTo(context, name: "pub-notebook"),
                    icon: const Icon(
                      Icons.add_circle,
                      color: fkBlueText,
                    ))
              ],
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: PubNotebookSheet(),
      )
    ]));
  }
}
