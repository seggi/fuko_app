import 'package:flutter/material.dart';
import 'package:fuko_app/screens/screen_list.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case '/home':
        if (args is Map) {
          return MaterialPageRoute(builder: (_) => HomePage(data: args));
        }
        return _errorRoute();
      case '/expenses':
        return MaterialPageRoute(builder: (_) => ExpensesPage());
      case '/expense-options':
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => ExpenseOptionsScreen(data: args));
        }
        return _errorRoute();
      case '/add-expense':
        return MaterialPageRoute(builder: (_) => const AddExpensesScreen());
      case '/expenses/summary':
        return MaterialPageRoute(builder: (_) => const SammaryScreen());
      case '/expenses/details':
        return MaterialPageRoute(
            builder: (_) => const ExpensesSammaryDetails());
      case '/complete-profile':
        if (args is Map) {
          return MaterialPageRoute(builder: (_) => CompleteProfile(data: args));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
