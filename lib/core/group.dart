import 'dart:convert';

import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/api.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:http/http.dart' as http;

class GroupData {
  final String? description;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? amount;
  final String? groupDeleted;
  final String? groupName;
  final String? isAdmin;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? requestedAt;
  final String? requestStatus;

  GroupData(
      {this.createdAt,
      this.description,
      this.id,
      this.updatedAt,
      this.amount,
      this.groupDeleted,
      this.groupName,
      this.isAdmin,
      this.username,
      this.firstName,
      this.requestStatus,
      this.requestedAt,
      this.lastName});

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
        description: json["description"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
        id: json["id"].toString(),
        amount: json["amount"].toString(),
        groupName: json["group_name"].toString(),
        isAdmin: json["is_admin"].toString(),
        groupDeleted: json["group_deleted"].toString(),
        firstName: json["first_name"].toString(),
        lastName: json["last_name"].toString(),
        requestStatus: json["request_status_name"].toString(),
        requestedAt: json["requested_at"].toString(),
        username: json["username"].toString());
  }
}

Future<List<GroupData>> fetchGroupList() async {
  var token = await UserPreferences.getToken();
  final response = await http.get(Uri.parse(Network.getGroupList),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var groupList = jsonDecode(response.body)["all_group"] as List;

    return groupList.map((group) => GroupData.fromJson(group)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<GroupData>> fetchMemberContribution({groupId, currencyCode}) async {
  var token = await UserPreferences.getToken();
  final response = await http.get(
      Uri.parse("${Network.retrieveMemberContribution}/$groupId/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var groupList = jsonDecode(response.body)["data"] as List;

    return groupList.map((group) => GroupData.fromJson(group)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<GroupData>> fetchParticipator(
    {contributionId, currencyCode}) async {
  var token = await UserPreferences.getToken();
  final response = await http.get(
      Uri.parse(
          "${Network.retrieveParticipator}/$contributionId/$currencyCode"),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var groupList = jsonDecode(response.body)["data"] as List;

    return groupList.map((group) => GroupData.fromJson(group)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<GroupData>> fetchRequestSent() async {
  var token = await UserPreferences.getToken();
  final response = await http.get(Uri.parse(Network.groupRequest),
      headers: Network.authorizedHeaders(token: token));

  if (response.statusCode == 200) {
    var groupList = jsonDecode(response.body)["data"] as List;

    return groupList.map((group) => GroupData.fromJson(group)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
