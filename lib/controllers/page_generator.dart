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
        builder: (context, state) => const CompleteProfile(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'expenses',
            builder: (context, state) => ExpensesPage(),
            routes: [
              GoRoute(
                name: "expense-options",
                path: 'expense-options',
                builder: (context, state) => const ExpenseOptionsScreen(),
              ),
              GoRoute(
                name: "save-expenses",
                path: 'save-expenses',
                builder: (context, state) => const SaveExpenses(),
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
