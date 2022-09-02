import 'package:flutter/material.dart';
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
  static String createNotebook = liveUrl! + "/notebook/create";
  static String getNotebook = liveUrl! + "/notebook/retrieve";
  static String getNotebookMember =
      liveUrl! + "/notebook/retrieve-notebook-member";
  static String getNotebookRequestSent = liveUrl! + "/notebook/request-sent";
  static String getInComingRequest = liveUrl! + "/notebook/received-request";
  static String confirmRejectRequest =
      liveUrl! + "/notebook/confirm-reject-request";
  static String getMemberFromDeptNotebook =
      liveUrl! + "/account/dept/friend-pub-dept-notebook";
  static String linkNotebookMemberToDeptNotebook =
      liveUrl! + "/notebook/link-dept-notebook-notebook-member";
  static String linkNotebookMemberToLoanNotebook =
      liveUrl! + "/notebook/link-loan-notebook-notebook-member";
  static String inviteFriend = liveUrl! + "/notebook/invite-friend";
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

  static String getPrivateLoanList =
      liveUrl! + "/account/loans/personal-loan-notebook";
  static String getLoanList = liveUrl! + "/account/loans/retrieve";
  static String addPrivateLoan =
      liveUrl! + "/account/loans/add-people-notebook";
  static String retrievePersonalLoan =
      liveUrl! + "/account/loans/retrieve-friend-loan";
  static String retrievedPaidAmount =
      liveUrl! + "/account/loans/retrieved-paid-amount";

  static String recordLoan = "${liveUrl!}/account/loans/record-loan";
  static String privatePaidLoanPayment =
      "${liveUrl!}/account/loans/reimburse-loan";
  static String getMemberFromLoanNotebook =
      "${liveUrl!}/account/loans/pub-loan-notebook";

  static String getBudgetList = "${liveUrl!}/budget/retrieve-all";
  static String registerBudgetName = "${liveUrl!}/budget/create-budget";
  static String addEnvelope = "${liveUrl!}/budget/add-envelope-budget";
  static String getBudgetCategories = "${liveUrl!}/budget/budget-category";
  static String getEnvelopeList = "${liveUrl!}/budget/get-envelope";

  static String getGroupList = "${liveUrl!}/account/group/retrieve-group";
  static String createGroup = "${liveUrl!}/account/group/create-group";
  static String groupRequest =
      "${liveUrl!}/account/group/retrieve-request-sent";
  static String inviteFriendToGroup =
      "${liveUrl!}/account/group/add-partner-to-your-group";
  static String confirmedCanceledGr =
      "${liveUrl!}/account/group/cancel-accept-reject-request";
  static String retrieveMemberContribution =
      "${liveUrl!}/account/group/retrieve-member-contribution";
  static String retrieveParticipator =
      "${liveUrl!}/account/group/retrieve-participator";
  static String saveGroupContributor =
      "${liveUrl!}/account/group/save-group-contribution";
}
