import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/user_preferences.dart';
import '../provider/authentication.dart';

class NavDrawer extends StatelessWidget {
  final String username;
  const NavDrawer({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String username = this.username;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              username,
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: const BoxDecoration(
                color: fkDefaultColor,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              UserPreferences.removeToken();
              context.read<AuthenticationData>().logout();
              context.go('/');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
