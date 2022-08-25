import 'package:fuko_app/core/budget.dart';
import 'package:fuko_app/core/currency_data.dart';
import 'package:fuko_app/core/months_data.dart';
import 'package:intl/intl.dart';

var defaultCurrency = 150;
var income = 1;
var expense = 2;
late Future<List<GetCurrencies>> retrieveCurrencies;
late Future<List<GetMonths>> retrieveMonths;
late Future<List<BudgetData>> retrieveBudgetCategories;
late Future<List<BudgetData>> retrieveBudgetPeriod;
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

List<Map<String, Object>> budgetPeriodList = [
  {
    "id": 1,
    "budget": "Zero period",
    "description":
        "Use the Zero period when the budget is not assigned to a specific month, but to the entire fiscal year."
  },
  {
    "id": 2,
    "budget": "Monthly periods",
    "description":
        "Use Enter Budget Amount Options and Budget routines to load monthly budgets."
  },
  {
    "id": 3,
    "budget": "Period 13",
    "description":
        "Use Annualized Budget when you want to project the actual current year amounts to the end of the year."
  },
];
