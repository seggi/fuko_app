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
  final String currencyCode;
  final String amount;
  final String description;
  final String createdAt;
  final String updatedAat;

  RetrieveDetailsExpenses(
      {required this.currencyCode,
      required this.amount,
      required this.description,
      required this.createdAt,
      required this.updatedAat});

  factory RetrieveDetailsExpenses.fromJson(Map<String, dynamic> json) {
    return RetrieveDetailsExpenses(
        currencyCode: json["code"].toString(),
        amount: json["amount"].toString(),
        description: json["description"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString());
  }
}

class RetrieveExpenses {
  final String currencyCode;
  final String expenseId;
  final String expenseName;
  final String createdAt;
  final String updatedAat;

  RetrieveExpenses(
      {required this.currencyCode,
      required this.expenseId,
      required this.expenseName,
      required this.createdAt,
      required this.updatedAat});

  factory RetrieveExpenses.fromJson(Map<String, dynamic> json) {
    return RetrieveExpenses(
        currencyCode: json["code"].toString(),
        expenseId: json["id"].toString(),
        expenseName: json["expense_name"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString());
  }
}

Future<List<RetrieveExpenses>> fetchRetrieveExpenses(
    {String? currencyId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse("${Network.getExpenses}/150"),
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
  final String currencyCode;
  final String totalAmount;

  RetrieveExpensesTotal({
    required this.currencyCode,
    required this.totalAmount,
  });

  factory RetrieveExpensesTotal.fromJson(Map<String, dynamic> json) {
    return RetrieveExpensesTotal(
      currencyCode: json["currency_code"].toString(),
      totalAmount: json["total"].toString(),
    );
  }
}

// Retrieve total amount on expenses
Future<RetrieveExpensesTotal> fetchRetrieveExpensesTotal(
    {String? currencyId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse("${Network.getExpenses}/$currencyId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveExpensesTotal.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}

// Retrieve list of expenses
class RetrieveDetailsExpensesListByDate {
  final String? currencyCode;
  final List? expenseList;
  final String? totalAmount;
  final String? date;

  RetrieveDetailsExpensesListByDate(
      {this.currencyCode, this.expenseList, this.totalAmount, this.date});

  factory RetrieveDetailsExpensesListByDate.fromJson(
      Map<String, dynamic> json) {
    return RetrieveDetailsExpensesListByDate(
        currencyCode: json["currency_code"],
        expenseList: json["expenses_list"],
        totalAmount: json["total_amount"].toString(),
        date: json["today_date"].toString());
  }
}

Future<List<RetrieveDetailsExpenses>> fetchExpensesDetailList(
    {String? expenseId, String? currencyId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.expensesDetails + "/$expenseId/$currencyId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var expensesData =
        jsonDecode(response.body)["data"]["expenses_list"] as List;

    return expensesData
        .map((expense) => RetrieveDetailsExpenses.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<RetrieveDetailsExpensesListByDate> fetchDetailsExpensesTotalAmountByDate(
    {String? expenseId, String? currencyId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.expensesDetails + "/$expenseId/$currencyId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveDetailsExpensesListByDate.fromJson(
        jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}
