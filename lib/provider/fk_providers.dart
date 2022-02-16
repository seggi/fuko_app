import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fuko_app/provider/navigator.dart';

class FkProvider {
  // This is called at the root of app
  static List<SingleChildWidget> multi() {
    return [
      ListenableProvider<NavigationPath>(create: (_) => NavigationPath()),
    ];
  }
}
