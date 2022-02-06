import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/navigation.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:provider/provider.dart';
import 'package:fuko_app/screens/screen_list.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ListenableProvider<NavigationController>(
        create: (_) => NavigationController(),
      )
    ],
    child: FukoApp(),
  ));
}

class FukoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fuko',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: fkDefaultColor,
            secondary: const Color(0XFFF9F9F9),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Navigator(
          pages: getPages(context),
          onPopPage: (route, result) {
            bool popStatus = route.didPop(result);
            if (popStatus == true) {
              Provider.of<NavigationController>(context, listen: false)
                  .changeScreen('/');
              Provider.of<NavigationController>(context, listen: false)
                  .changeScreen('/home');
            }
            return popStatus;
          },
        ));
  }
}

List<Page> getPages(context) {
  NavigationController navigation = Provider.of<NavigationController>(context);
  List<Page> pageList = [];

  pageList.add(MaterialPage(child: LoanPage()));

  switch (navigation.screenName) {
    case '/login':
      pageList.add(MaterialPage(child: HomePage()));
      break;
    case '/expenses':
      pageList.add(MaterialPage(child: ExpensesPage()));
      break;
  }

  return pageList;
}
