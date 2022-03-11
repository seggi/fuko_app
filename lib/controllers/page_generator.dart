import 'package:fuko_app/provider/authentication.dart';
import 'package:fuko_app/screens/budget/budget_details.dart';
import 'package:fuko_app/screens/screen_list.dart';
import 'package:go_router/go_router.dart';

import 'manage_provider.dart';

final loginInfo = AuthenticationData();

class PagesGenerator {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/complete-profile',
        builder: (context, state) => CompleteProfile(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          final data = state.queryParams['status'];
          return HomePage(status: data);
        },
        routes: [
          GoRoute(
            path: 'expenses',
            builder: (context, state) {
              final data = state.queryParams['status'];
              return ExpensesPage(status: data);
            },
            routes: [
              GoRoute(
                name: "expense-options",
                path: 'expense-options',
                builder: (context, state) => const ExpenseOptionsScreen(),
              ),
              GoRoute(
                name: "save-expenses",
                path: 'save-expenses/:id',
                builder: (context, state) {
                  var expenseId = state.params['id']!;
                  return SaveExpenses(
                    id: expenseId,
                  );
                },
              ),
              GoRoute(
                name: "create-expense",
                path: 'create-expense',
                builder: (context, state) => const CreateExpense(),
              ),
              GoRoute(
                name: "expense-list",
                path: 'expense-list/:id',
                builder: (context, state) {
                  var data = state.params['id']!;
                  return ExpenseList(id: data);
                },
              ),
            ],
          ),
          GoRoute(
              path: 'budget',
              builder: (context, state) => const BudgetScreen(),
              routes: [
                GoRoute(
                    name: 'budget-detail',
                    path: 'budget-detail/:title',
                    builder: (context, state) {
                      final data = state.params['title']!;
                      return BudgetDetails(
                        title: data,
                      );
                    }),
              ]),
          GoRoute(
            path: 'saving',
            builder: (context, state) {
              final data = state.queryParams['status'];
              return SavingPage(status: data);
            },
            routes: [
              GoRoute(
                name: "saving-options",
                path: 'saving-options',
                builder: (context, state) => const ExpenseOptionsScreen(),
              ),
              GoRoute(
                name: "register-saving",
                path: 'register-saving',
                builder: (context, state) => const RegisterSavingScreen(),
              ),
            ],
          ),
        ],
        redirect: (state) {
          final loggedIn = loginInfo.loggedIn;
          final loggingIn = state.subloc == '/login';
          if (!loggedIn) return loggingIn ? null : '/login';
          if (loggingIn) return '/';

          return null;
        },
      ),
    ],
    refreshListenable: loginInfo,
  );

  // Call this method to navigate to the next screen
  static goTo(context,
      {String? name,
      String? pathName,
      Map<String, String> params = const {},
      Map<String, String> queryParams = const {},
      Object? extra,
      itemData = "notFound",
      provider = "notFound"}) {
    if (pathName != null) {
      FkManageProviders.save[provider](context, itemData: itemData);
      return GoRouter.of(context).go(pathName, extra: extra);
    } else {
      FkManageProviders.save[provider](context, itemData: itemData);
      return GoRouter.of(context).goNamed(name!,
          params: params, queryParams: queryParams, extra: extra);
    }
  }

  static directTo(context, {String? pathName, itemData, provider, token}) {
    FkManageProviders.save["login"](context, itemData: token);
    FkManageProviders.save[provider](context, itemData: itemData);
    return GoRouter.of(context).go(pathName!);
  }
}
