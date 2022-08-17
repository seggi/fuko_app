import 'package:fuko_app/provider/authentication.dart';
import 'package:fuko_app/screens/budget/budget_details.dart';
import 'package:fuko_app/screens/dept/pay_private_dept.dart';
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
        builder: (context, state) {
          final data = state.queryParams['status'];
          return HomePage(status: data);
        },
        routes: [
          GoRoute(
            path: 'dashboard',
            builder: (context, state) {
              final data = state.queryParams['status'];
              return DashBoardPage(status: data);
            },
          ),
          GoRoute(
              path: 'notebook',
              builder: (context, state) {
                return const NotebookPage();
              },
              routes: [
                GoRoute(
                  name: "notebook-member",
                  path: 'notebook-member/:id',
                  builder: (context, state) {
                    var notebookId = state.params['id']!;
                    return NotebookMember(
                      id: notebookId,
                    );
                  },
                ),
                GoRoute(
                  name: "invite-friend-to-notebook",
                  path: 'invite-friend-to-notebook/:id',
                  builder: (context, state) {
                    var notebookId = state.params['id']!;
                    return InviteFriendToNotebook(
                      id: notebookId,
                    );
                  },
                ),
                GoRoute(
                  name: "incoming-request",
                  path: 'incoming-request',
                  builder: (context, state) {
                    return const IncomingRequest();
                  },
                ),
                GoRoute(
                    path: "request-sent",
                    name: "request-sent",
                    builder: (context, state) {
                      return const RequestSent();
                    })
              ]),
          GoRoute(
              path: 'groupe',
              builder: (context, state) {
                return const GroupePage();
              },
              routes: [
                GoRoute(
                  name: 'groupe-detail',
                  path: 'groupe-detail',
                  builder: (context, state) {
                    return const GroupDetail();
                  },
                ),
              ]),
          GoRoute(
            path: 'expenses',
            builder: (context, state) {
              final data = state.queryParams['status'];
              return ExpensesPage(status: data);
            },
            routes: [
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
              GoRoute(
                name: "update-expense-name",
                path: 'update-expense-name/:id',
                builder: (context, state) {
                  var data = state.params['id']!;
                  return UpdateExpenseName(expenseId: data);
                },
              ),
              GoRoute(
                name: "expense-report",
                path: 'expense-report',
                builder: (context, state) {
                  return const ExpenseReport();
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
                name: "register-saving",
                path: 'register-saving',
                builder: (context, state) => const RegisterSavingScreen(),
              ),
              GoRoute(
                name: "saving-report",
                path: 'saving-report',
                builder: (context, state) {
                  return const SavingReport();
                },
              ),
            ],
          ),
          GoRoute(
              path: 'dept',
              name: 'dept',
              builder: (context, state) {
                final data = state.queryParams['status'];
                return DeptPage(status: data);
              },
              routes: [
                GoRoute(
                  name: "pub-notebook",
                  path: 'pub-notebook',
                  builder: (context, state) => const CreatePubNoteBook(),
                ),
                GoRoute(
                  name: "add-borrow-manually",
                  path: 'add-borrow-manually',
                  builder: (context, state) => const AddBorrowerManually(),
                ),
                GoRoute(
                  name: "add-borrow-from-fuko",
                  path: 'add-borrow-from-fuko',
                  builder: (context, state) => const AddBorrowerFromFuko(),
                ),
                GoRoute(
                    name: "borrower_dept_details",
                    path: 'borrower_dept_details/:id',
                    builder: (context, state) {
                      var data = state.params['id']!;
                      return BorrowerDeptList(
                        id: data,
                      );
                    },
                    routes: [
                      GoRoute(
                        name: "save-dept",
                        path: 'save-dept/:id',
                        builder: (context, state) {
                          var data = state.params['id']!;
                          return RecordBorrowerDept(
                            id: data,
                          );
                        },
                      ),
                      GoRoute(
                        name: "pay-private-dept",
                        path: 'pay-private-dept/:id',
                        builder: (context, state) {
                          var data = state.params['id']!;
                          return PayPrivateDept(
                            id: data,
                          );
                        },
                      ),
                    ]),
              ]),
          // LenderLoanList
          GoRoute(
              path: "loan",
              name: 'loan',
              builder: (context, state) {
                final data = state.queryParams['status'];
                return LoanPage(status: data);
              },
              routes: [
                GoRoute(
                  name: "add-lender-manually",
                  path: 'add-lender-manually',
                  builder: (context, state) => const AddLenderManually(),
                ),
                GoRoute(
                  name: "lender-loan-details",
                  path: 'lender-loan-details/:id',
                  builder: (context, state) {
                    var data = state.params['id']!;
                    return LenderLoanList(
                      id: data,
                    );
                  },
                )
              ])
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
