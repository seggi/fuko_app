import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  Widget build(BuildContext context) {
    return FkScrollViewWidgets.body(
      context,
      itemList: [
        Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.cancel_outlined),
                        onPressed: () => PagesGenerator.goTo(context,
                            pathName: "/?status=true")),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
