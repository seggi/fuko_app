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

  GroupData({
    this.createdAt,
    this.description,
    this.id,
    this.updatedAt,
    this.amount,
    this.groupDeleted,
    this.groupName,
    this.isAdmin,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
        description: json["description"].toString(),
        createdAt: json['created_at'].toString(),
        updatedAt: json['updated_at'].toString(),
        id: json['id'].toString(),
        amount: json["amount"].toString(),
        groupName: json["group_name"].toString(),
        isAdmin: json["is_admin"].toString(),
        groupDeleted: json["group_deleted"].toString());
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
