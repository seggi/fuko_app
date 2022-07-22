import 'dart:convert';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:fuko_app/core/user_preferences.dart';

class MonthlyTotalAmount {
  final String? totalAmount;

  MonthlyTotalAmount({this.totalAmount});

  factory MonthlyTotalAmount.fromJson(Map<String, dynamic> json) {
    return MonthlyTotalAmount(totalAmount: json["total_amount"].toString());
  }
}

Future<MonthlyTotalAmount> fetchMonthlyTotalAmount() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.expenseReport),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return MonthlyTotalAmount.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
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
