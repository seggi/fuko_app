import 'package:fuko_app/provider/providers_list.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class FkProvider {
  // This is called at the root of app
  static List<SingleChildWidget> multi() {
    return [
      ListenableProvider<NavigationPath>(create: (_) => NavigationPath()),
      ChangeNotifierProvider(
        create: (_) => AuthenticationData(),
      ),
      ChangeNotifierProvider(create: (_) => AddExpenses()),
      ChangeNotifierProvider(create: (_) => AuthenticationData())
    ];
  }
}
