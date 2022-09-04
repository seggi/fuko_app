import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/group.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class EditParticipator extends StatefulWidget {
  const EditParticipator({Key? key}) : super(key: key);

  @override
  State<EditParticipator> createState() => _EditParticipatorState();
}

class _EditParticipatorState extends State<EditParticipator> {
  late Future<List<GroupData>> retrieveGroupMember;

  @override
  Widget build(BuildContext context) {
    final groupId = FkManageProviders.get(context)['get-id'];
    final List newItems = FkManageProviders.get(context)["get-list-items"];

    Map<String?, bool> checkBoxListValues = {};

    setState(() {
      retrieveGroupMember = fetchGroupMember(groupId: groupId);
    });

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

                          // saveGroupMember(context, itemData: {
                          //   "id": "${snapshot.data?[index].id}",
                          //   "full_name":
                          //       "${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}"
                          // });

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CheckboxListTile(
                                // leading: const CircleAvatar(
                                //   backgroundColor: fkGreyText,
                                //   child: Icon(
                                //     Icons.person,
                                //     size: 30,
                                //     color: fkWhiteText,
                                //   ),
                                // ),
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
                                        newValue ?? false;
                                  });
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
