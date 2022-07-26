import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:http/http.dart' as http;

class RetrieveBorrowersList {
  final String? borrowerId;
  final String? amount;
  final String? firstName;
  final String? lastName;
  final String? borrowerName;
  final String? createdAt;
  final String? updatedAat;
  final String? totalDept;
  final String? currencyCode;

  RetrieveBorrowersList(
      {this.borrowerId,
      this.amount,
      this.borrowerName,
      this.firstName,
      this.lastName,
      this.createdAt,
      this.updatedAat,
      this.totalDept,
      this.currencyCode});

  factory RetrieveBorrowersList.fromJson(Map<String, dynamic> json) {
    return RetrieveBorrowersList(
        borrowerId: json["id"].toString(),
        amount: json["amount"].toString(),
        borrowerName: json["borrower_name"].toString(),
        firstName: json["first_name"].toString(),
        lastName: json["last_name"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAat: json["updated_at"].toString(),
        totalDept: json["total_dept"].toString(),
        currencyCode: json["currency"].toString());
  }
}

// Retrieve List of Borrowers
Future<List<RetrieveBorrowersList>> fetchBorrowerList() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getBorrowerList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var borrowerDataList = jsonDecode(response.body)["data"] as List;

    return borrowerDataList
        .map((user) => RetrieveBorrowersList.fromJson(user))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

// Retrieve total Dept amount
Future<RetrieveBorrowersList> fetchDeptAmount({setCurrency}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getTotalDeptAmount + '/$setCurrency'),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveBorrowersList.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}

// Dept details
class RetrieveDept {
  final String? deptId;
  final String? amount;
  final String? description;
  final String? lentAt;
  final String? paymentStatus;
  final String? createdAt;
  final String? totalDeptAmount;
  final String? todayDate;
  final String? currencyCode;

  RetrieveDept(
      {this.deptId,
      this.amount,
      this.description,
      this.lentAt,
      this.paymentStatus,
      this.createdAt,
      this.totalDeptAmount,
      this.todayDate,
      this.currencyCode});

  factory RetrieveDept.fromJson(Map<String, dynamic> json) {
    return RetrieveDept(
        deptId: json['id'].toString(),
        amount: json['amount'].toString(),
        description: json['description'].toString(),
        lentAt: json['lent_at'].toString(),
        paymentStatus: json['payment_status'].toString(),
        createdAt: json['created_at'].toString(),
        totalDeptAmount: json['total_amount'].toString(),
        todayDate: json['today_date'].toString(),
        currencyCode: json['currency'].toString());
  }
}

Future<List<RetrieveDept>> fetchBorrowerDept({String? borrowerId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getBorrowerDept + "/$borrowerId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var borrowerDataList =
        jsonDecode(response.body)["data"]["dept_list"] as List;

    return borrowerDataList
        .map((expense) => RetrieveDept.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<RetrieveDept> fetchTotalDeptAmount({String? borrowerId}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getBorrowerDept + "/$borrowerId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveDept.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}
