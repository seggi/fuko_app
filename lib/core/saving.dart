import 'dart:convert';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class RetrieveSaving {
  final String? amount;
  final String? description;
  final String? createdAt;
  final String? updatedAat;
  final String? currencyCode;

  RetrieveSaving(
      {this.amount,
      this.description,
      this.createdAt,
      this.updatedAat,
      this.currencyCode});

  factory RetrieveSaving.fromJson(Map<String, dynamic> json) {
    return RetrieveSaving(
        amount: json["amount"].toString(),
        description: json["description"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString(),
        currencyCode: json["code"].toString());
  }
}

// Retrieve list of expenses
Future<List<RetrieveSaving>> fetchRetrieveSaving({setCurrency}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getSavingListByDate + "/$setCurrency"),
      headers: Network.authorizedHeaders(token: token));
  if (response.statusCode == 200) {
    var expensesData = jsonDecode(response.body)["data"]["saving_list"] as List;
    return expensesData
        .map((expense) => RetrieveSaving.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class RetrieveSavingTotal {
  final String? totalAmount;
  final String? todayDate;
  final String? currencyCode;

  RetrieveSavingTotal({this.totalAmount, this.todayDate, this.currencyCode});

  factory RetrieveSavingTotal.fromJson(Map<String, dynamic> json) {
    return RetrieveSavingTotal(
        totalAmount: json["total_amount"]['amount'].toString(),
        todayDate: json["today_date"].toString(),
        currencyCode: json["total_amount"]["currency"].toString());
  }
}

// Retrieve total amount on expenses
Future<RetrieveSavingTotal> fetchRetrieveSavingTotal({setCurrency}) async {
  var token = await UserPreferences.getToken();
  final response = await http.get(
      Uri.parse(Network.getSavingListByDate + "/$setCurrency"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveSavingTotal.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}
