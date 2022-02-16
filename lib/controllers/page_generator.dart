import 'package:flutter/material.dart';
import 'package:fuko_app/provider/navigator.dart';
import 'package:fuko_app/screens/screen_list.dart';
import 'package:provider/provider.dart';

class PagesGenerator {
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
    }
    return pageList;
  }

  // Call this method to navigate to the next screen
  static goTo(context, {flag = false, pathName}) {
    if (pathName != "") {
      return Provider.of<NavigationPath>(context, listen: flag)
          .changeScreen(pathName);
    } else {
      return Provider.of<NavigationPath>(context);
    }
  }

  // This allow us navigate to the previous screen
  static backTo(context, {rt, res}) {
    bool popStatus = rt.didPop(res);
    if (popStatus == true) {
      PagesGenerator.goTo(context, pathName: "/");
    }
    return popStatus;
  }
}
