import 'dart:convert';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class RetrieveSaving {
  final String amount;
  final String description;
  final String createdAt;
  final String updatedAat;

  RetrieveSaving(
      {required this.amount,
      required this.description,
      required this.createdAt,
      required this.updatedAat});

  factory RetrieveSaving.fromJson(Map<String, dynamic> json) {
    return RetrieveSaving(
        amount: json["amount"].toString(),
        description: json["description"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString());
  }
}

// Retrieve list of expenses
Future<List<RetrieveSaving>> fetchRetrieveSaving() async {
  var token = await UserPreferences.getToken();
  var userId = await UserPreferences.getUserId();

  final response = await http.get(
      Uri.parse(Network.getSavingListByDate + "/$userId"),
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
  final String totalAmount;
  final String todayDate;

  RetrieveSavingTotal({required this.totalAmount, required this.todayDate});

  factory RetrieveSavingTotal.fromJson(Map<String, dynamic> json) {
    return RetrieveSavingTotal(
      totalAmount: json["total_amount"].toString(),
      todayDate: json["today_date"].toString(),
    );
  }
}

// Retrieve total amount on expenses
Future<RetrieveSavingTotal> fetchRetrieveSavingTotal() async {
  var token = await UserPreferences.getToken();
  var userId = await UserPreferences.getUserId();

  final response = await http.get(
      Uri.parse(Network.getSavingListByDate + "/$userId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveSavingTotal.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}
