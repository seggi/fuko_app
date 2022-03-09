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

class RetrieveDetailsExpenses {
  final String userId;
  final String amount;
  final String description;

  final String createdAt;
  final String updatedAat;

  RetrieveDetailsExpenses(
      {required this.userId,
      required this.amount,
      required this.description,
      required this.createdAt,
      required this.updatedAat});

  factory RetrieveDetailsExpenses.fromJson(Map<String, dynamic> json) {
    return RetrieveDetailsExpenses(
        userId: json["users"].toString(),
        amount: json["amount"].toString(),
        description: json["description"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString());
  }
}

Future<List<RetrieveDetailsExpenses>> fetchRetrieveDetailsExpenses() async {
  var token = await UserPreferences.getToken();
  var userId = await UserPreferences.getUserId();

  final response = await http.get(
      Uri.parse(Network.expensesDetails + "/$userId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var expensesData = jsonDecode(response.body)["data"]["expense"] as List;
    return expensesData
        .map((expense) => RetrieveDetailsExpenses.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class RetrieveExpenses {
  final String expenseId;
  final String expenseName;
  final String createdAt;
  final String updatedAat;

  RetrieveExpenses(
      {required this.expenseId,
      required this.expenseName,
      required this.createdAt,
      required this.updatedAat});

  factory RetrieveExpenses.fromJson(Map<String, dynamic> json) {
    return RetrieveExpenses(
        expenseId: json["id"].toString(),
        expenseName: json["expense_name"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString());
  }
}

Future<List<RetrieveExpenses>> fetchRetrieveExpenses() async {
  var token = await UserPreferences.getToken();
  var userId = await UserPreferences.getUserId();

  final response = await http.get(Uri.parse(Network.getExpenses + "/$userId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var expensesData = jsonDecode(response.body)["data"]["expense"] as List;
    return expensesData
        .map((expense) => RetrieveExpenses.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class RetrieveExpensesTotal {
  final String totalAmount;

  RetrieveExpensesTotal({
    required this.totalAmount,
  });

  factory RetrieveExpensesTotal.fromJson(Map<String, dynamic> json) {
    return RetrieveExpensesTotal(
      totalAmount: json["total"].toString(),
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
