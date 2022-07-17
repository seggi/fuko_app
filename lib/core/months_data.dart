import 'package:fuko_app/utils/constant.dart';

class GetMonths {
  final String? name;
  final String? number;

  GetMonths({this.name, this.number});

  factory GetMonths.fromJson(Map<String, dynamic> json) {
    return GetMonths(
        name: json['name'].toString(), number: json['number'].toString());
  }
}

Future<List<GetMonths>> fetchMonthsList({String? borrowerId}) async {
  var months = monthsList;
  return months.map((month) => GetMonths.fromJson(month)).toList();
}
