import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';

customBottomModalSheet(BuildContext context) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('Add Borrower from Fuko Users'),
              onTap: () {
                PagesGenerator.goTo(context, name: "add-borrow-from-fuko");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('Add Borrower Manually'),
              onTap: () {
                PagesGenerator.goTo(context, name: "add-borrow-manually");
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20.0)
          ],
        );
      });
}
