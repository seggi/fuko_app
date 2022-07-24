import 'dart:convert';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:fuko_app/core/user_preferences.dart';

class MonthlyTotalAmount {
  final String? totalAmount;
  final String? currencyCode;
  MonthlyTotalAmount({this.totalAmount, this.currencyCode});

  factory MonthlyTotalAmount.fromJson(Map<String, dynamic> json) {
    return MonthlyTotalAmount(
        totalAmount: json["total_amount"].toString(),
        currencyCode: json["currency_code"].toString());
  }
}

Future<MonthlyTotalAmount> fetchMonthlyTotalAmount(
    {String? currencyCode, String? selectedYear}) async {
  var token = await UserPreferences.getToken();
  var year = selectedYear ?? currentYear;
  var currency = currencyCode ?? defaultCurrency;

  try {
    final response = await http.get(
        Uri.parse(Network.expenseReport + "/$currency/$year"),
        headers: Network.authorizedHeaders(token: token));
    if (response.statusCode == 200) {
      return MonthlyTotalAmount.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw e;
  }
}

class MonthlyReportDetail {
  final List? data;
  final String? month;
  final String? totalAmount;

  MonthlyReportDetail({this.data, this.month, this.totalAmount});

  factory MonthlyReportDetail.fromJson(Map<String, dynamic> json) {
    return MonthlyReportDetail(
        data: json["data"],
        month: json["month"],
        totalAmount: json["total_amount"]);
  }
}

Future<List<MonthlyReportDetail>> fetchMonthlyReportDetail() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.expenseReport),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var expensesData = jsonDecode(response.body)["monthly_report"] as List;

    return expensesData
        .map((report) => MonthlyReportDetail.fromJson(report))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}
