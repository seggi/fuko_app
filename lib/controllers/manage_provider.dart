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
    "save-screen-title": (context, {screenTitle, expenseDescriptionId}) =>
        Provider.of<AddExpenses>(context, listen: false)
            .addScreenTitle(screenTitle: screenTitle),
    "save-expense-descriptionId": (context, {expenseDescriptionId}) =>
        Provider.of<AddExpenses>(context, listen: false)
            .addExpenseDescriptionId(expenseDescriptionId),
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
        Provider.of<RecordAmount>(context, listen: false).add(itemData),
    "remove-dept": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false).remove(itemData),
    "remove-all-dept": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false).removeFromList(),
    "save-dept-amount": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false).addAmount(itemData),
    "save-borrower-id": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false)
            .saveBorrowerId(itemData),

    // Loan Section
    "save_new_lender": (context, {itemData}) =>
        Provider.of<SaveNewBorrower>(context, listen: false).add(itemData),
    "record-loan": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false).add(itemData),
    "remove-loan": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false).remove(itemData),
    "remove-all-loan": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false).removeFromList(),
    "save-loan-amount": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false).addAmount(itemData),
    "save-lender-id": (context, {itemData}) =>
        Provider.of<RecordAmount>(context, listen: false)
            .saveBorrowerId(itemData),

    "save-select-item": (context, {itemData}) =>
        Provider.of<SelectFromDataList>(context, listen: false).add(itemData),
    "save-list-items": (context, {itemData}) =>
        Provider.of<SelectFromDataList>(context, listen: false)
            .addItem(itemData),
    "add-selected-budget": (context, {periods}) =>
        Provider.of<SelectFromDataList>(context, listen: false)
            .addPeriod(periods),
    "save-id": (context, {id}) =>
        Provider.of<SelectFromDataList>(context, listen: false).saveId(id),
    "save-request-number": (context, {number}) =>
        Provider.of<SelectFromDataList>(context, listen: false)
            .saveRequestNumber(number),
    "save-amount-one": (context, {amount}) =>
        Provider.of<SelectFromDataList>(context, listen: false)
            .amountOne(amount),
    "save-amount-two": (context, {amount}) =>
        Provider.of<SelectFromDataList>(context, listen: false)
            .amountTwo(amount),
  };

  static get(context) {
    return {
      "auth": Provider.of<AuthenticationData>(context).getUserData,
      "get-token": Provider.of<AuthenticationData>(context).userToken,
      "add-expenses": Provider.of<AddExpenses>(context).getNewItem,
      "get-added-expenses": Provider.of<AddExpenses>(context).getTotalAmount,
      "get-screen-title": Provider.of<AddExpenses>(context).screenTitle,
      "get-expense-descriptionId":
          Provider.of<AddExpenses>(context).expenseDescriptionId,
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
      "get-added-dept": Provider.of<RecordAmount>(context).getNewItem,
      "get-total-dept-amount":
          Provider.of<RecordAmount>(context).getTotalAmount,
      "get-borrower-id": Provider.of<RecordAmount>(context).borrowerId,

      // loan
      "get-lender": Provider.of<SaveNewBorrower>(context).getUserData,
      "get-added-loan": Provider.of<RecordAmount>(context).getNewItem,
      "get-total-loan-amount":
          Provider.of<RecordAmount>(context).getTotalAmount,
      "get-loan-id": Provider.of<RecordAmount>(context).borrowerId,

      "get-item-selected": Provider.of<SelectFromDataList>(context).getNewItem,
      "get-period-selected": Provider.of<SelectFromDataList>(context).getPeriod,
      "get-id": Provider.of<SelectFromDataList>(context).getId,
      "get-list-items": Provider.of<SelectFromDataList>(context).getNewItemList,
      "get-request-number":
          Provider.of<SelectFromDataList>(context).getRequestNumber,
      "get-total-computed-amount":
          Provider.of<SelectFromDataList>(context).getTotalComputedAmount,
      "get-amount-one": Provider.of<SelectFromDataList>(context).getAmountOne,
      "get-amount-two": Provider.of<SelectFromDataList>(context).getAmountTwo,
    };
  }

  static Map remove = {
    "remove-items": (context) =>
        Provider.of<SelectFromDataList>(context, listen: false).remove(),
    "remove-participator": (context, {itemData}) =>
        Provider.of<SelectFromDataList>(context, listen: false)
            .removeParticipator(itemData),
    "remove-envelope": (context) =>
        Provider.of<SelectFromDataList>(context, listen: false)
            .removeEnvelope(),
    "remove-expense-descriptionId": (context) =>
        Provider.of<AddExpenses>(context, listen: false)
            .removeExpenseDescriptionId(),
    "remove-amount-saved": (context) =>
        Provider.of<SelectFromDataList>(context, listen: false)
            .removeTotalAmount()
  };
}
