import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:http/http.dart' as http;

class BudgetData {
  final String? description;
  final String? id;
  final String? title;
  final String? createdAt;
  final String? updatedAt;
  final String? budgetCategory;
  final String? budget;

  BudgetData(
      {this.createdAt,
      this.description,
      this.id,
      this.title,
      this.updatedAt,
      this.budget,
      this.budgetCategory});

  factory BudgetData.fromJson(Map<String, dynamic> json) {
    return BudgetData(
      description: json["description"].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
      title: json['name'].toString(),
      id: json['id'].toString(),
      budget: json['budget'].toString(),
      budgetCategory: json['name'].toString(),
    );
  }
}

Future<List<BudgetData>> fetchBudgetList() async {
  var token = await UserPreferences.getToken();
  final response = await http.get(Uri.parse(Network.getBudgetList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var budgetList = jsonDecode(response.body)["data"] as List;

    return budgetList.map((user) => BudgetData.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<BudgetData>> fetchBudgetCategories() async {
  var token = await UserPreferences.getToken();
  final response = await http.get(Uri.parse(Network.getBudgetCategories),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var budgetList = jsonDecode(response.body)["data"] as List;

    return budgetList.map((user) => BudgetData.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<BudgetData>> fetchBudgetPeriod() async {
  var periodList = budgetPeriodList;
  return periodList.map((period) => BudgetData.fromJson(period)).toList();
}
