import 'dart:convert';

import 'package:fuko_app/controllers/manage_provider.dart';
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
  final String? username;
  final String? notebook;
  final String? loanMembership;

  RetrieveBorrowersList(
      {this.borrowerId,
      this.amount,
      this.borrowerName,
      this.firstName,
      this.lastName,
      this.createdAt,
      this.updatedAat,
      this.totalDept,
      this.username,
      this.notebook,
      this.loanMembership,
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
        username: json["username"].toString(),
        notebook: json["notebook_name"].toString(),
        loanMembership: json["loan_notebook_membership_id"].toString(),
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

// Retrieve List of members from dept notebook
Future<List<RetrieveBorrowersList>> fetchMemberFromDeptNotebook() async {
  var token = await UserPreferences.getToken();

  final response = await http.get(Uri.parse(Network.getMemberFromDeptNotebook),
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
  final String? totalDept;
  final String? username;
  final String? paidAmount;
  final String? loanMembership;

  RetrieveDept(
      {this.deptId,
      this.amount,
      this.description,
      this.lentAt,
      this.paymentStatus,
      this.createdAt,
      this.totalDeptAmount,
      this.todayDate,
      this.totalDept,
      this.paidAmount,
      this.username,
      this.loanMembership,
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
        totalDept: json["total_dept"].toString(),
        paidAmount: json["paid_amount"].toString(),
        username: json["username"].toString(),
        loanMembership: json["loan_notebook_membership_id"].toString(),
        currencyCode: json['currency'].toString());
  }
}

Future<List<RetrieveDept>> fetchBorrowerDept(
    {String? borrowerId, currencyCode, loanMembership}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getBorrowerDept + "/$borrowerId/$currencyCode"),
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

Future<List<RetrieveDept>> fetchBorrowerPaymentHistory(
    {String? noteId, currencyCode, loanMembership}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.privatePaidDeptHistory +
          "/$noteId/${loanMembership == null || loanMembership == "0" ? 0 : loanMembership}/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var borrowerDataList =
        jsonDecode(response.body)["data"]["payment_history"] as List;

    return borrowerDataList
        .map((expense) => RetrieveDept.fromJson(expense))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<RetrieveDept> fetchTotalPaidAmount(
    {String? noteId, currencyCode, loanMembership}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.privatePaidDeptHistory +
          "/$noteId/${loanMembership == null || loanMembership == "null" ? 0 : loanMembership}/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return RetrieveDept.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}

Future retrieveTotalDept(
    {context,
    String? borrowerId,
    currencyCode,
    loanMembership,
    String? noteId}) async {
  var token = await UserPreferences.getToken();
  var saveAmount = FkManageProviders.save["save-amount-one"];
  var saveAmountTwo = FkManageProviders.save["save-amount-two"];

  final response = await http.get(
      Uri.parse(Network.getBorrowerDept + "/$borrowerId/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  final responseOne = await http.get(
      Uri.parse(Network.privatePaidDeptHistory +
          "/$noteId/${loanMembership == null || loanMembership == "null" ? 0 : loanMembership}/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    saveAmount(context,
        amount: jsonDecode(response!.body)["data"]["total_dept"]);
    saveAmountTwo(context,
        amount: jsonDecode(responseOne!.body)["data"]["paid_amount"]);

    var totalAmount = RetrieveDept.fromJson(jsonDecode(response.body)["data"]);
    return totalAmount;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<RetrieveDept> fetchTotalDeptAmount(
    {context, String? borrowerId, currencyCode, loanMembership}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getBorrowerDept + "/$borrowerId/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var totalAmount = RetrieveDept.fromJson(jsonDecode(response.body)["data"]);
    return totalAmount;
  } else {
    throw Exception('Failed to load data');
  }
}

class ReportCardTotal {
  final String? currencyCode;
  final String? paidAmount;
  final bool? paymentStatus;

  ReportCardTotal({this.currencyCode, this.paidAmount, this.paymentStatus});

  factory ReportCardTotal.fromJson(Map<String, dynamic> json) {
    return ReportCardTotal(
        currencyCode: json["currency"].toString(),
        paidAmount: json["paid_amount"].toString(),
        paymentStatus: json["status"]);
  }
}

Future<ReportCardTotal> fetchReportCardTotal({deptId, currencyCode}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getDeptDetails + "/$currencyCode/$deptId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    return ReportCardTotal.fromJson(jsonDecode(response.body)["data"]);
  } else {
    throw Exception('Failed to load data');
  }
}

class ReportCardData {
  final String? amount;
  final String? description;
  final String? createdAt;

  ReportCardData({this.amount, this.description, this.createdAt});

  factory ReportCardData.fromJson(Map<String, dynamic> json) {
    return ReportCardData(
        amount: json["amount"].toString(),
        description: json["description"].toString(),
        createdAt: json["created_at"].toString());
  }
}

Future<List<ReportCardData>> fetchReportCardData({deptId, currencyCode}) async {
  var token = await UserPreferences.getToken();

  final response = await http.get(
      Uri.parse(Network.getDeptDetails + "/$currencyCode/$deptId"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var deptPaymentReport =
        jsonDecode(response.body)["data"]["payment_history"] as List;

    return deptPaymentReport
        .map((dept) => ReportCardData.fromJson(dept))
        .toList();
  } else {
    throw Exception('Failed to load data');
  }
}
