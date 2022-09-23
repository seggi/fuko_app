// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
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
  final String? paidAmount;
  final String? description;
  final String? deptMemberShip;
  final bool? paymentStatus;

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
      this.paidAmount,
      this.paymentStatus,
      this.description,
      this.deptMemberShip,
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
        description: json["description"].toString(),
        paidAmount: json["paid_amount"].toString(),
        deptMemberShip: json['dept_notebook_membership_id'].toString(),
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

Future retrieveTotalLoan(
    {context,
    String? lenderId,
    currencyCode,
    String? noteId,
    String? loanMembership}) async {
  var token = await UserPreferences.getToken();
  var saveAmount = FkManageProviders.save["save-amount-one"];
  var saveAmountTwo = FkManageProviders.save["save-amount-two"];

  final response = await http.get(
      Uri.parse(Network.retrievePersonalLoan +
          "/$lenderId/${loanMembership == 0 ? 0 : loanMembership}/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  final responseOne = await http.get(
      Uri.parse(Network.retrievedPaidAmount + "/$noteId/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    saveAmount(context,
        amount: jsonDecode(response!.body)["data"]["total_loan"]);
    saveAmountTwo(context,
        amount: jsonDecode(responseOne!.body)["data"]["paid_amount"]);

    var totalAmount = LoanList.fromJson(jsonDecode(response.body)["data"]);
    return totalAmount;
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

Future<List<LoanList>> fetchLenderLoan(
    {String? lenderId, currencyCode, deptMembership = 0}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.retrievePersonalLoan +
          "/$lenderId/${deptMembership == 0 ? 0 : deptMembership}/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var lenderList = jsonDecode(response.body)["data"]["loan_list"] as List;

    return lenderList.map((expense) => LoanList.fromJson(expense)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<LoanList> fetchTotalLoanAmount(
    {String? lenderId, currencyCode, deptMembership = 0}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.retrievePersonalLoan +
          "/$lenderId/${deptMembership == 0 ? 0 : deptMembership}/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var loanList = LoanList.fromJson(jsonDecode(response.body)["data"]);

    return loanList;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<LoanList>> fetchPaymentHistory(
    {String? noteId, currencyCode}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.retrievedPaidAmount + "/$noteId/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var borrowerDataList =
        jsonDecode(response.body)["data"]["payment_history"] as List;

    return borrowerDataList
        .map((expense) => LoanList.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<LoanList> fetchTotalLenderPaidAmount(
    {String? noteId, currencyCode}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.retrievedPaidAmount + "/$noteId/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return LoanList.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<LoanList>> fetchMemberFromLoanNotebook() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getMemberFromLoanNotebook),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var borrowerDataList = jsonDecode(response.body)["data"] as List;

    return borrowerDataList.map((user) => LoanList.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
