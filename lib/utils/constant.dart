import 'package:fuko_app/core/currency_data.dart';
import 'package:fuko_app/core/months_data.dart';
import 'package:intl/intl.dart';

var defaultCurrency = 150;
late Future<List<GetCurrencies>> retrieveCurrencies;
late Future<List<GetMonths>> retrieveMonths;
late List? retrieveExpensesDetailListByMonth;

List<Map<String, Object>> monthsList = [
  {"name": "January", "number": 1},
  {"name": "February", "number": 2},
  {"name": "March", "number": 3},
  {"name": "April", "number": 4},
  {"name": "May", "number": 5},
  {"name": "June", "number": 6},
  {"name": "July", "number": 7},
  {"name": "August", "number": 8},
  {"name": "September", "number": 9},
  {"name": "October", "number": 10},
  {"name": "November", "number": 11},
  {"name": "December", "number": 12}
];

// Display current year

var now = DateTime.now();
var formatter = DateFormat('yyyy');
String currentYear = formatter.format(now);

final DateTime today = DateTime.now();
final DateFormat formatterDate = DateFormat('yyyy-MM-dd');
var todayDate = formatterDate.format(today);

String amountPaymentLabel = "Pay one part";
String singlePaymentMethod = "single";
