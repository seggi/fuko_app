import 'package:flutter_dotenv/flutter_dotenv.dart';

class Network {
  static String? liveUrl = dotenv.env['ONLINE_URL'];
  static String login = liveUrl! + "/login";
  static String register = liveUrl! + "/signup";
  static String completeProfile = liveUrl! + "/profile/complete-profile";
  static Map<String, String> authorizedHeaders({token}) => {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token",
      };
  static String globalAmount = liveUrl! + "/account/global-amount";
  static String addExpenses = liveUrl! + "/account/add-expenses";
  static String getExpenses = liveUrl! + "/account/expenses";
  static String getExpensesByDate = liveUrl! + "/account/expenses-by-date";
  static String getSavingListByDate =
      liveUrl! + "/account/savings/retrieve-by-date";
  static String registerSaving = liveUrl! + "/account/savings/add-saving";
}
