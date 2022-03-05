import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class SaveExpenses {
  final int userId;
  final double amount;
  final String title;
  final String description;

  SaveExpenses(
      {required this.amount,
      required this.userId,
      required this.description,
      required this.title});

  factory SaveExpenses.fromJson(Map<String, dynamic> json) {
    return SaveExpenses(
        amount: json["amount"],
        userId: json["user_id"],
        description: json["description"],
        title: json["title"]);
  }
}

class RetrieveExpenses {
  final String userId;
  final String amount;
  final String description;
  final String title;
  final String createdAt;
  final String updatedAat;

  RetrieveExpenses(
      {required this.userId,
      required this.amount,
      required this.description,
      required this.title,
      required this.createdAt,
      required this.updatedAat});

  factory RetrieveExpenses.fromJson(Map<String, dynamic> json) {
    return RetrieveExpenses(
        userId: json["users"].toString(),
        amount: json["amount"].toString(),
        description: json["description"].toString(),
        title: json["title"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString());
  }
}

class RetrieveExpensesTotal {
  final String totalAmount;
  // final Map expenseList;
  RetrieveExpensesTotal({
    required this.totalAmount,
    // required this.expenseList
  });

  factory RetrieveExpensesTotal.fromJson(Map<String, dynamic> json) {
    return RetrieveExpensesTotal(
      totalAmount: json["total_amount"].toString(),
      // expenseList: json['expenses_list']
    );
  }
}

// Retrieve total amount on expenses
Future<RetrieveExpensesTotal> fetchRetrieveExpensesTotal() async {
  var token = await UserPreferences.getToken();
  var userId = await UserPreferences.getUserId();

  final response = await http.get(Uri.parse(Network.getExpenses + "/$userId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveExpensesTotal.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}

// Retrieve list of expenses
Future<List<RetrieveExpenses>> fetchRetrieveExpenses() async {
  var token = await UserPreferences.getToken();
  var userId = await UserPreferences.getUserId();

  final response = await http.get(
      Uri.parse(Network.getExpensesByDate + "/$userId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var expensesData =
        jsonDecode(response.body)["data"]["expenses_list"] as List;
    return expensesData
        .map((expense) => RetrieveExpenses.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}
