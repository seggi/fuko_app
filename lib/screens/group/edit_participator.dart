import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class EditParticipator extends StatefulWidget {
  const EditParticipator({Key? key}) : super(key: key);

  @override
  State<EditParticipator> createState() => _EditParticipatorState();
}

class _EditParticipatorState extends State<EditParticipator> {
  @override
  Widget build(BuildContext context) {
    final groupId = FkManageProviders.get(context)['get-id'];
    final List newItems = FkManageProviders.get(context)["get-list-items"];
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
                            name: "add-contribution")),
                  ],
                ),
              ),
              verticalSpaceRegular,
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: const Text(
                  "Edit participation member",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              verticalSpaceSmall,
              Expanded(
                child: newItems.isNotEmpty
                    ? ListView.builder(
                        itemCount: newItems.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                              key: UniqueKey(),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(
                                    key: UniqueKey(),
                                    onDismissed: () {
                                      FkManageProviders
                                              .remove["remove-expenses"](
                                          context,
                                          itemData: {
                                            "full_name": newItems[index]
                                                ['full_name'],
                                          });
                                    }),
                                children: const [
                                  SlidableAction(
                                    onPressed: doNothingsFive,
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Remove',
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                leading: const Icon(
                                  Icons.delete_sweep,
                                  color: Color(0xFFFE4A49),
                                ),
                                title: Text(newItems[index]['full_name']),
                                trailing: Text(
                                    "${double.parse(newItems[index]['amount'])}"),
                              ));
                        },
                      )
                    : const Center(
                        child: Text("Empty List"),
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

doNothingsFive(BuildContext context) {}
