import 'package:fuko_app/provider/providers_list.dart';
import 'package:provider/provider.dart';

class FkManageProviders {
  static Map saves = {
    "notFound": (context, {itemData}) => [],
    "auth": (context, {itemData}) =>
        Provider.of<AuthenticationData>(context, listen: false).add(itemData),
    "save-expenses": (context, {itemData}) =>
        Provider.of<SaveExpenses>(context, listen: false).add(itemData)
  };

  static get(context) {
    return {"auth": Provider.of<AuthenticationData>(context).getUserData};
  }
}
