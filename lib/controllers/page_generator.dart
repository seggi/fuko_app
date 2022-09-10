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
            path: 'profile',
            builder: (context, state) {
              final data = state.queryParams['data'];
              return ProfileScreen(data: data);
            },
          ),
          GoRoute(
            path: 'dashboard',
            builder: (context, state) {
              final data = state.queryParams['status'];
              return DashBoardPage(status: data);
            },
          ),
          GoRoute(
            path: 'notification',
            builder: (context, state) {
              return const Notification();
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
                GoRoute(
                  name: 'create-group',
                  path: 'create-group',
                  builder: (context, state) {
                    return const CreateGroup();
                  },
                ),
                GoRoute(
                  name: 'invite-friend-to-group',
                  path: 'invite-friend-to-group',
                  builder: (context, state) {
                    return const InviteFriendToGroup();
                  },
                ),
                GoRoute(
                  name: 'add-contribution',
                  path: 'add-contribution',
                  builder: (context, state) {
                    return const AddContribution();
                  },
                ),
                GoRoute(
                  name: 'group-member',
                  path: 'group-member/:id',
                  builder: (context, state) {
                    var groupId = state.params['id']!;
                    return GroupMember(id: groupId);
                  },
                ),
                GoRoute(
                  name: 'edit-participator',
                  path: 'edit-participator/:groupId',
                  builder: (context, state) {
                    var groupId = state.params['groupId']!;
                    return EditParticipator(groupId: groupId);
                  },
                ),
                GoRoute(
                  name: 'gr-request-sent',
                  path: 'gr-request-sent',
                  builder: (context, state) {
                    return const GrRequestSent();
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
              builder: (context, state) {
                final data = state.queryParams['status'];
                return BudgetScreen(status: data);
              },
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
                GoRoute(
                    name: 'register-budget',
                    path: 'register-budget',
                    builder: (context, state) {
                      return const RegisterBudgetName();
                    }),
                GoRoute(
                    name: 'add-budget-details',
                    path: 'add-budget-details',
                    builder: (context, state) {
                      return const AddBudgetDetails();
                    }),
                GoRoute(
                    name: 'search-budget-category',
                    path: 'search-budget-category',
                    builder: (context, state) {
                      return const SearchBudgetCategory();
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
                    path: 'borrower_dept_details/:id/:loanMembership',
                    builder: (context, state) {
                      var data = state.params['id']!;
                      var loanMembership = state.params['loanMembership']!;
                      return BorrowerDeptList(
                          id: data, loanMembership: loanMembership);
                    },
                    routes: [
                      GoRoute(
                        name: "save-dept",
                        path: 'save-dept/:id/:loanMembership',
                        builder: (context, state) {
                          var data = state.params['id']!;
                          var loanMembership = state.params['loanMembership']!;
                          return RecordBorrowerDept(
                              id: data, loanMembership: loanMembership);
                        },
                      ),
                      GoRoute(
                        name: "pay-private-dept",
                        path: 'pay-private-dept/:id/:loanMembership',
                        builder: (context, state) {
                          var data = state.params['id']!;
                          var loanMembership = state.params['loanMembership']!;
                          return PayPrivateDept(
                              id: data, loanMembership: loanMembership);
                        },
                      ),
                    ]),
              ]),
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
                  path: 'lender-loan-details/:id/:deptMemberShip',
                  builder: (context, state) {
                    var id = state.params['id']!;
                    var deptMemberShip = state.params['deptMemberShip']!;
                    return LenderLoanList(
                      id: id,
                      deptMemberShip: deptMemberShip,
                    );
                  },
                ),
                GoRoute(
                  name: "save-loan",
                  path: 'save-loan/:id/:deptMemberShip',
                  builder: (context, state) {
                    var data = state.params['id']!;
                    var deptMemberShip = state.params['deptMemberShip']!;
                    return RecordLoan(
                      id: data,
                      deptMemberShip: deptMemberShip,
                    );
                  },
                ),
                GoRoute(
                  name: "pay-private-loan",
                  path: 'pay-private-loan/:id/:deptMemberShip',
                  builder: (context, state) {
                    var data = state.params['id']!;
                    var deptMemberShip = state.params['deptMemberShip']!;
                    return PayPrivateLoan(
                      id: data,
                      deptMemberShip: deptMemberShip,
                    );
                  },
                ),
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
