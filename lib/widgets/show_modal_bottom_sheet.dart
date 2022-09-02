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
              leading: const Icon(Icons.note_add),
              title: const Text('Create public notebook'),
              onTap: () {
                PagesGenerator.goTo(context, pathName: "/notebook");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('Add private dept notebook'),
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

customLoanBottomModalSheet(BuildContext context) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Create public notebook'),
              onTap: () {
                PagesGenerator.goTo(context, pathName: "/notebook");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('Add private loan notebook'),
              onTap: () {
                PagesGenerator.goTo(context, name: "add-lender-manually");
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20.0)
          ],
        );
      });
}

notebookCustomBottomModalSheet(BuildContext context,
    {fn, notebookMemberId, requestStatus, loading}) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.link,
                  color: Colors.blue,
                ),
                title: const Text('Confirm'),
                onTap: () {
                  PagesGenerator.goTo(context, name: "pub-notebook");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.cancel,
                  color: Colors.deepOrange,
                ),
                title: const Text('Cancel request'),
                onTap: () {
                  PagesGenerator.goTo(context, name: "add-borrow-manually");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}
