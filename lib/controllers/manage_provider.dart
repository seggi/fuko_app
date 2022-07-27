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
    "save-screen-title": (context, {screenTitle}) =>
        Provider.of<AddExpenses>(context, listen: false)
            .addScreenTitle(screenTitle),
    "add-currency": (context, {currencyId}) =>
        Provider.of<AddExpenses>(context, listen: false)
            .addCurrencyId(currencyId),
    "add-default-currency": (context, {currencyId}) =>
        Provider.of<AddExpenses>(context, listen: false)
            .addDefaultCurryId(currencyId),
    "add-selected-month": (context, {monthNumber}) =>
        Provider.of<AddExpenses>(context, listen: false)
            .addSelectedMonth(monthNumber),
    "add-selected-year": (context, {year}) =>
        Provider.of<AddExpenses>(context, listen: false).addSelectedYear(year),
    "update-status": (context, {status}) =>
        Provider.of<AddExpenses>(context, listen: false).checkStatus(status),

    // Saving section
    "register-saving": (context, {itemData}) =>
        Provider.of<RegisterSaving>(context, listen: false).add(itemData),
    "save-saving-amount": (context, {itemData}) =>
        Provider.of<RegisterSaving>(context, listen: false).addAmount(itemData),
    "remove-saving": (context, {itemData}) =>
        Provider.of<RegisterSaving>(context, listen: false).remove(itemData),
    "remove-all-saving": (context) =>
        Provider.of<RegisterSaving>(context, listen: false).removeFromList(),

    // Dept Section
    "save_new_borrower": (context, {itemData}) =>
        Provider.of<SaveNewBorrower>(context, listen: false).add(itemData),
    "record-dept": (context, {itemData}) =>
        Provider.of<RecordDept>(context, listen: false).add(itemData),
    "remove-dept": (context, {itemData}) =>
        Provider.of<RecordDept>(context, listen: false).remove(itemData),
    "remove-all-dept": (context, {itemData}) =>
        Provider.of<RecordDept>(context, listen: false).removeFromList(),
    "save-dept-amount": (context, {itemData}) =>
        Provider.of<RecordDept>(context, listen: false).addAmount(itemData),
    "save-borrower-id": (context, {itemData}) =>
        Provider.of<RecordDept>(context, listen: false)
            .saveBorrowerId(itemData),
  };

  static get(context) {
    return {
      "auth": Provider.of<AuthenticationData>(context).getUserData,
      "get-token": Provider.of<AuthenticationData>(context).userToken,
      "add-expenses": Provider.of<AddExpenses>(context).getNewItem,
      "get-added-expenses": Provider.of<AddExpenses>(context).getTotalAmount,
      "get-screen-title": Provider.of<AddExpenses>(context).screenTitle,
      "get-currency": Provider.of<AddExpenses>(context).currencyId,
      "get-default-currency":
          Provider.of<AddExpenses>(context).defaultCurrencyId,
      "get-selected-month": Provider.of<AddExpenses>(context).monthNumber,
      "get-selected-year": Provider.of<AddExpenses>(context).getYear,
      "get-status": Provider.of<AddExpenses>(context).getStatus,

      // Saving section
      "get-savings-item": Provider.of<RegisterSaving>(context).getNewItem,
      "get-added-saving": Provider.of<RegisterSaving>(context).getTotalAmount,

      // dept
      "get-borrowers": Provider.of<SaveNewBorrower>(context).getUserData,
      "get-added-dept": Provider.of<RecordDept>(context).getNewItem,
      "get-total-dept-amount": Provider.of<RecordDept>(context).getTotalAmount,
      "get-borrower-id": Provider.of<RecordDept>(context).borrowerId
    };
  }
}
