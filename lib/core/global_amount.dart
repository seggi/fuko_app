import 'dart:convert';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class GlobalAmount {
  late final String? globalAmount;
  late final Map? globalAmountDetails;
  late final String? totalDept;
  late final String? totalLoan;
  late final String? currencyCode;
  late final String? totalExpenses;
  late final String? totalSavings;

  GlobalAmount(
      {this.globalAmount,
      this.globalAmountDetails,
      this.totalDept,
      this.currencyCode,
      this.totalExpenses,
      this.totalSavings,
      this.totalLoan});

  factory GlobalAmount.fromJson(Map<String, dynamic> responseData) {
    return GlobalAmount(
        globalAmount: responseData['global_amount'].toString(),
        globalAmountDetails: responseData['global_amount_details'],
        totalDept: responseData['total_depts'].toString(),
        totalLoan: responseData['total_loans'].toString(),
        totalExpenses: responseData['total_expenses'].toString(),
        totalSavings: responseData['total_savings'].toString(),
        currencyCode: responseData['currencyCode'].toString());
  }
}

Future<GlobalAmount> fetchGlobalAmount({String? currencyId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.globalAmount + "/$currencyId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return GlobalAmount.fromJson(
        jsonDecode(response.body)["data"]["global_amount"]);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<GlobalAmount> fetchGlobalTotalDeptAndLoanAmount(
    {String? currencyId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.globalAmount + "/$currencyId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return GlobalAmount.fromJson(
        jsonDecode(response.body)["data"]['global_amount']);
  } else {
    throw Exception('Failed to load data');
  }
}
