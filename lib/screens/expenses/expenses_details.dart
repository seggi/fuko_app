import 'package:flutter/material.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/screens/expenses/expense_sam_details.dart';
import 'package:fuko_app/screens/expenses/summary.dart';

class ExpenseOptionsScreen extends StatefulWidget {
  const ExpenseOptionsScreen({Key? key}) : super(key: key);

  @override
  _ExpenseOptionsScreenState createState() => _ExpenseOptionsScreenState();
}

class _ExpenseOptionsScreenState extends State<ExpenseOptionsScreen> {
  int _selectedIndex = 0;
  final String title = "Expenses";
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    SummaryScreen(),
    ExpensesSummaryDetails()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FkContentBoxWidgetsWithBottomBar.body(
        selectedIndexItem: _selectedIndex,
        onItemTappedIcon: _onItemTapped,
        titleTxt: title,
        bottomItemList: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_out),
            label: 'Details',
          ),
        ],
        screenBox: _widgetOptions.elementAt(_selectedIndex));
  }
}
