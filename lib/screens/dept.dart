import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/dept.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/screens/dept/private_dept_sheet.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:fuko_app/widgets/show_modal_bottom_sheet.dart';

class DeptPage extends StatefulWidget {
  final String? status;

  const DeptPage({Key? key, required this.status}) : super(key: key);

  @override
  _DeptPageState createState() => _DeptPageState();
}

class _DeptPageState extends State<DeptPage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    PrivateDeptSheet(),
    Center(
      child: Text(
        'Screen not ready  yet...',
        style: optionStyle,
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FkContentBoxWidgets.body(context, 'dept',
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        itemList: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () async {
                          PagesGenerator.goTo(context,
                              pathName: "/?status=true");
                        },
                        child: const Icon(Icons.arrow_back_ios)),
                    const Text(
                      "Dept",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => customBottomModalSheet(context),
                        // PagesGenerator.goTo(context, name: "create-expense"),
                        icon: const Icon(
                          Icons.person_add_alt,
                          color: fkBlueText,
                        )),
                    IconButton(
                        onPressed: () => customBottomModalSheet(context),
                        icon: const Icon(
                          Icons.note_add,
                          color: fkBlueText,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search_sharp,
                          color: fkBlueText,
                        )),
                  ],
                )
              ],
            ),
          ),
          _widgetOptions.elementAt(_selectedIndex)
        ]);
  }
}
