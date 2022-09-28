import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/group.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../controllers/page_generator.dart';
import '../widgets/shared/style.dart';
import 'content_box_widgets.dart';

class GroupePage extends StatefulWidget {
  const GroupePage({Key? key}) : super(key: key);

  @override
  State<GroupePage> createState() => _GroupePageState();
}

class _GroupePageState extends State<GroupePage> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<GroupData>> retrieveGroupName;
  late Future<List<GroupData>> retrieveGroupMember;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveGroupName = fetchGroupList();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.save["save-screen-title"];
    final saveId = FkManageProviders.save['save-id'];
    final saveGroupCreator = FkManageProviders.save['save-select-item'];

    setState(() {
      retrieveGroupName = fetchGroupList();
    });

    return Container(
        child: FkContentBoxWidgets.body(context, 'groupe', itemList: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        var token = await UserPreferences.getToken();
                        PagesGenerator.goTo(context, pathName: "/?status=true");
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  const Text(
                    "Groupe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () =>
                          PagesGenerator.goTo(context, name: "create-group"),
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: fkBlackText,
                      )),
                  IconButton(
                    onPressed: () =>
                        PagesGenerator.goTo(context, name: "gr-request-sent"),
                    icon: const Icon(
                      FontAwesomeIcons.squareArrowUpRight,
                      color: fkBlackText,
                      size: 20,
                    ),
                  )
                ],
              )
            ],
          )),
      Expanded(
        child: FutureBuilder<List<GroupData>>(
          future: retrieveGroupName,
          builder: (
            BuildContext context,
            AsyncSnapshot snapshot,
          ) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    child: const Center(child: Text("No group")));
              }
              return Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification:
                      (OverscrollIndicatorNotification? overscroll) {
                    overscroll!.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      double idGroup = double.parse(snapshot.data?[index].id);
                      return Card(
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              retrieveGroupMember = fetchGroupMember(
                                  context: context,
                                  groupId: idGroup.toInt().toString());
                            });
                            saveId(context, id: idGroup.toInt().toString());
                            saveGroupCreator(context, itemData: {
                              "creator": snapshot.data?[index].creator
                            });
                            screenTitle(context,
                                screenTitle:
                                    "${snapshot.data?[index].groupName}");
                            PagesGenerator.goTo(context, name: "groupe-detail");
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: fkGreyText,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: const Icon(
                              FontAwesomeIcons.userGroup,
                              color: fkWhiteText,
                            ),
                          ),
                          title: Text(
                            "${snapshot.data?[index].groupName}",
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                          subtitle: Text(
                            "Admin ➤ ${snapshot.data?[index].creator == true ? 'You' : snapshot.data?[index].username}",
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                          trailing: const Text(
                            "🗂",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong:('));
            }
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      ),
    ]));
  }
}
