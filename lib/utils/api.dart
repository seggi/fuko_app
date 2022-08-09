import 'package:flutter_dotenv/flutter_dotenv.dart';

class Network {
  // static String? liveUrl = dotenv.env['LOCAL_URL'];
  static String? liveUrl = dotenv.env['ONLINE_URL'];
  static String login = liveUrl! + "/login";
  static String register = liveUrl! + "/signup";
  static String completeProfile = liveUrl! + "/profile/complete-profile";
  static Map<String, String> authorizedHeaders({token}) => {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token",
      };
  static String globalAmount = liveUrl! + "/account/global-amount";
  static String addExpenses = liveUrl! + "/account/add-expenses-details";
  static String getExpenses = liveUrl! + "/account/expenses";
  static String getExpensesByDate = liveUrl! + "/account/expenses-by-date";
  static String updateExpenseName = liveUrl! + "/account/update-expense";
  static String getSavingListByDate =
      liveUrl! + "/account/savings/retrieve-by-current-date";
  static String registerSaving = liveUrl! + "/account/savings/add-saving";
  static String retrieveSavingReport =
      liveUrl! + "/account/savings/retrieve-saving-report";
  static String createExpense = liveUrl! + "/account/create-expenses";
  static String expensesDetails = liveUrl! + "/account/expense-details";
  static String getExpensesDetailsByMonth =
      liveUrl! + "/account/expenses-by-month";
  static String getBorrowerList =
      liveUrl! + "/account/dept/get-friend-from-dept-notebook";
  static String addNewBorrower =
      liveUrl! + "/account/dept/add-borrower-to-notebook";
  static String getTotalDeptAmount = liveUrl! + "/account/dept/retrieve";
  static String addNewBorrowerManually =
      liveUrl! + "/account/dept/add-people-notebook";
  static String searchUser = liveUrl! + "/manage_request/search-user";
  static String getBorrowerDept =
      liveUrl! + "/account/dept/retrieve-friend-dept";
  static String getDeptDetails =
      liveUrl! + "/account/dept/retrieve-paid-amount";
  static String personalManageDept =
      liveUrl! + "/account/dept/pay-borrowed-amount";
  static String privatePaidDeptHistory =
      liveUrl! + "/account/dept/retrieved-paid-amount";
  static String privatePaidDeptPayment =
      liveUrl! + "/account/dept/pay-many-dept";
  static String recordDept = liveUrl! + "/account/dept/record-dept";
  static String currencies = liveUrl! + "/manage_request/retrieve-curries";
  static String yearsList = liveUrl! + "/manage_request/retrieve-years";
  static String expenseReport = liveUrl! + "/account//expense-report";
}
