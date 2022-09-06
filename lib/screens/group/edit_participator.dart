import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/group.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class EditParticipator extends StatefulWidget {
  final String? groupId;
  const EditParticipator({Key? key, this.groupId}) : super(key: key);

  @override
  State<EditParticipator> createState() => _EditParticipatorState();
}

class _EditParticipatorState extends State<EditParticipator> {
  late Future<List<GroupData>> retrieveGroupMember;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveGroupMember = fetchGroupMember(groupId: widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    final saveGroupMember = FkManageProviders.save['save-list-items'];

    final removeParticipator = FkManageProviders.remove['remove-participator'];

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
                child: FutureBuilder(
                  future: retrieveGroupMember,
                  builder: (context, AsyncSnapshot<List<GroupData>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No member found.'),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No member found.'),
                            );
                          }

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CheckboxListTile(
                                title: SizedBox(
                                  width: 200,
                                  child: Text(
                                    "${snapshot.data?[index].username}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  "${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                value: snapshot.data?[index].isSelected,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    snapshot.data?[index].isSelected =
                                        newValue!;
                                  });

                                  if (newValue == false) {
                                    removeParticipator(context, itemData: {
                                      "id": "${snapshot.data?[index].id}"
                                    });
                                  }

                                  if (newValue == true) {
                                    saveGroupMember(context, itemData: {
                                      "id": "${snapshot.data?[index].id}",
                                    });
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Something went wrong :('));
                    }

                    return const SizedBox(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                    );
                  },
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
