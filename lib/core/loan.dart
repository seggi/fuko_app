import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class LoanList {
  final String? id;
  final String? amount;
  final String? firstName;
  final String? lastName;
  final String? lenderName;
  final String? createdAt;
  final String? updatedAat;
  final String? totalLoan;
  final String? currencyCode;
  final String? username;
  final String? notebook;

  LoanList(
      {this.id,
      this.amount,
      this.firstName,
      this.createdAt,
      this.lenderName,
      this.updatedAat,
      this.totalLoan,
      this.currencyCode,
      this.username,
      this.notebook,
      this.lastName});

  factory LoanList.fromJson(Map<String, dynamic> json) {
    return LoanList(
        id: json["id"].toString(),
        amount: json["amount"].toString(),
        lenderName: json["partner_name"].toString(),
        firstName: json["first_name"].toString(),
        lastName: json["last_name"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString(),
        totalLoan: json["total_loan"].toString(),
        username: json["username"].toString(),
        notebook: json["notebook_name"].toString(),
        currencyCode: json["currency"].toString());
  }
}

Future<List<LoanList>> fetchPrivateLoanList() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getPrivateLoanList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var loanList = jsonDecode(response.body)["data"] as List;

    return loanList.map((user) => LoanList.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<LoanList>> fetchPubLoanList() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getBorrowerList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var loanList = jsonDecode(response.body)["data"] as List;

    return loanList.map((user) => LoanList.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<LoanList> fetchLoanAmount({setCurrency}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getLoanList + '/$setCurrency'),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return LoanList.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}
