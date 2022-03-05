import 'package:fuko_app/provider/providers_list.dart';
import 'package:provider/provider.dart';

class FkManageProviders {
  static Map save = {
    "notFound": (context, {itemData}) => [],
    "auth": (context, {itemData}) =>
        Provider.of<AuthenticationData>(context, listen: false).add(itemData),
    "login": (context, {itemData}) =>
        Provider.of<AuthenticationData>(context, listen: false).login(itemData),

    // Expenses section
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

    // Saving section
    "register-saving": (context, {itemData}) =>
        Provider.of<RegisterSaving>(context, listen: false).add(itemData),
    "save-saving-amount": (context, {itemData}) =>
        Provider.of<RegisterSaving>(context, listen: false).addAmount(itemData),
    "remove-saving": (context, {itemData}) =>
        Provider.of<RegisterSaving>(context, listen: false).remove(itemData),
    "remove-all-saving": (context) =>
        Provider.of<RegisterSaving>(context, listen: false).removeFromList(),
  };

  static get(context) {
    return {
      "auth": Provider.of<AuthenticationData>(context).getUserData,
      "get-token": Provider.of<AuthenticationData>(context).userToken,
      "add-expenses": Provider.of<AddExpenses>(context).getNewItem,
      "get-added-expenses": Provider.of<AddExpenses>(context).getTotalAmount,

      // Saving section
      "get-savings-item": Provider.of<RegisterSaving>(context).getNewItem,
      "get-added-saving": Provider.of<RegisterSaving>(context).getTotalAmount,
    };
  }
}
