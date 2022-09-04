import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/group.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';

class GroupMember extends StatefulWidget {
  final String id;
  const GroupMember({Key? key, required this.id}) : super(key: key);

  @override
  State<GroupMember> createState() => _GroupMemberState();
}

class _GroupMemberState extends State<GroupMember> {
  bool loading1 = false;
  bool loading = false;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<GroupData>> retrieveGroupMember;

  @override
  void initState() {
    super.initState();
    retrieveGroupMember = fetchGroupMember(groupId: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final groupId = widget.id;
    final saveGroupMember = FkManageProviders.save['save-list-items'];
    setState(() {
      retrieveGroupMember = fetchGroupMember(groupId: groupId);
    });

    return Container(
        child: FkContentBoxWidgets.body(context, 'notebook', itemList: [
      Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  iconSize: 18,
                  onPressed: () =>
                      PagesGenerator.goTo(context, name: "groupe-detail"),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
                const Text(
                  "Group member",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
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
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No member found.'),
                    );
                  }

                  saveGroupMember(context, itemData: {
                    "id": "${snapshot.data?[index].id}",
                    "full_name":
                        "${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}"
                  });

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: fkGreyText,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: fkWhiteText,
                          ),
                        ),
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
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong :('));
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            );
          },
        ),
      ),
    ]));
  }
}
