import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class RetrieveBorrowersList {
  final String? borrowerId;
  final String? amount;
  final String? borrowerName;
  final String? createdAt;
  final String? updatedAat;
  final String? totalDept;

  RetrieveBorrowersList(
      {this.borrowerId,
      this.amount,
      this.borrowerName,
      this.createdAt,
      this.updatedAat,
      this.totalDept});

  factory RetrieveBorrowersList.fromJson(Map<String, dynamic> json) {
    return RetrieveBorrowersList(
        borrowerId: json["users"].toString(),
        amount: json["amount"].toString(),
        borrowerName: json["borrower_name"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString(),
        totalDept: json["total_dept"].toString());
  }
}

// Retrieve List of Borrowers
Future<List<RetrieveBorrowersList>> fetchBorrowerList() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getBorrowerList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var expensesData = jsonDecode(response.body)["data"]["dept_list"] as List;

    return expensesData
        .map((expense) => RetrieveBorrowersList.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

// Retrieve total Dept amount
Future<RetrieveBorrowersList> fetchDeptAmount() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getBorrowerList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveBorrowersList.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}
