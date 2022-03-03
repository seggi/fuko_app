import 'dart:convert';

class BackendFeedBack {
  late String code;
  late String message;

  BackendFeedBack({required this.code, required this.message});

  factory BackendFeedBack.fromJson(Map<String, dynamic> json) {
    return BackendFeedBack(code: json['code'], message: json['message']);
  }
}
