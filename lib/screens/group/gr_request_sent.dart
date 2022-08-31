import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class GrRequestSent extends StatefulWidget {
  const GrRequestSent({Key? key}) : super(key: key);

  @override
  State<GrRequestSent> createState() => _GrRequestSentState();
}

class _GrRequestSentState extends State<GrRequestSent> {
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
                            name: "invite-friend-to-group")),
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
