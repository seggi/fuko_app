import 'package:flutter/material.dart';
import 'package:fuko_app/provider/navigator.dart';
import 'package:fuko_app/screens/screen_list.dart';
import 'package:provider/provider.dart';

import 'manage_provider.dart';

class PagesGenerator {
  // List all pages
  List<Page> getPage(context) {
    List<Page> pageList = [];
    NavigationPath navigation = Provider.of<NavigationPath>(context);

    pageList.add(const MaterialPage(child: LoginPage()));

    switch (navigation.screenPath) {
      case '/home':
        pageList.add(const MaterialPage(child: HomePage()));
        break;
      case '/login':
        pageList.add(const MaterialPage(child: LoginPage()));
        break;
      case '/register':
        pageList.add(const MaterialPage(child: SignUpPage()));
        break;
      case '/complete-profile':
        pageList.add(MaterialPage(child: CompleteProfile()));
        break;
      case '/expenses':
        pageList.add(MaterialPage(child: ExpensesPage()));
        break;
      case '/expense-options':
        pageList.add(const MaterialPage(child: ExpenseOptionsScreen()));
        break;
      case '/add-expense':
        pageList.add(const MaterialPage(child: AddExpensesScreen()));
        break;
      case '/save-expenses':
        pageList.add(const MaterialPage(child: SaveExpenses()));
    }
    return pageList;
  }

  // Call this method to navigate to the next screen
  static goTo(context,
      {flag = false, pathName, itemData = "notFound", provider = "notFound"}) {
    if (pathName != "") {
      FkManageProviders.saves[provider](context, itemData: itemData);
      return Provider.of<NavigationPath>(context, listen: flag)
          .changeScreen(pathName);
    } else {
      FkManageProviders.saves[provider](context, itemData: itemData);
      return Provider.of<NavigationPath>(context);
    }
  }

  // This allow us navigate to the previous screen
  static backTo(context, {rt, res}) {
    bool popStatus = rt.didPop(res);
    if (popStatus == true) {
      PagesGenerator.goTo(context, pathName: "/");
    }
    if (popStatus == true) {
      PagesGenerator.goTo(context, pathName: "/expenses");
    }
    return popStatus;
  }
}
