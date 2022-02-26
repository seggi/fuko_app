import 'package:fuko_app/provider/providers_list.dart';
import 'package:provider/provider.dart';

class FkManageProviders {
  static Map save = {
    "notFound": (context, {itemData}) => [],
    "auth": (context, {itemData}) =>
        Provider.of<AuthenticationData>(context, listen: false).add(itemData),
    "save-expenses": (context, {itemData}) =>
        Provider.of<SaveExpenses>(context, listen: false).add(itemData),
    "add-expenses": (context, {itemData}) =>
        Provider.of<AddExpenses>(context, listen: false).add(itemData),
    "save-expenses-amount": (context, {itemData}) =>
        Provider.of<AddExpenses>(context, listen: false).addAmount(itemData),
    "remove-expenses": (context, {itemData}) =>
        Provider.of<AddExpenses>(context, listen: false).remove(itemData),
    "remove-all-expenses": (context) =>
        Provider.of<AddExpenses>(context, listen: false).removeFromList(),
  };

  static get(context) {
    return {
      "auth": Provider.of<AuthenticationData>(context).getUserData,
      "add-expenses": Provider.of<AddExpenses>(context).getNewItem,
      "get-added-expenses": Provider.of<AddExpenses>(context).getTotalAmount,
    };
  }
}
