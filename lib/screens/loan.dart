import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/loan.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/screens/loan/private_loan_sheet.dart';
import 'package:fuko_app/screens/loan/pub_member_loan.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/show_modal_bottom_sheet.dart';

class LoanPage extends StatefulWidget {
  final String? status;
  const LoanPage({Key? key, required this.status}) : super(key: key);

  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions = <Widget>[
    const PrivateLoanSheet(),
    const PubMemberLoanNotebookSheet()
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
            padding: const EdgeInsets.only(
              right: 20.0,
              left: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          PagesGenerator.goTo(context,
                              pathName: "/?status=true");
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    const Text(
                      "Loan",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => customLoanBottomModalSheet(context),
                        icon: const Icon(
                          Icons.person_add_alt,
                          color: fkBlackText,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search_sharp,
                          color: fkBlackText,
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
