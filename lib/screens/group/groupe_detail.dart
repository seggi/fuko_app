import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/group.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/expanded/contribution_details.dart';

import '../../controllers/page_generator.dart';
import '../../widgets/draggable/custom_draggable_sheet.dart';
import '../../widgets/shared/style.dart';
import '../../widgets/shared/ui_helper.dart';
import '../content_box_widgets.dart';

class GroupDetail extends StatefulWidget {
  const GroupDetail({Key? key}) : super(key: key);

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<GroupData>> retrieveMemberContribution;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // retrieveMemberContribution = fetchMemberContribution(
    //     groupId: FkManageProviders.get(context)['get-id'],
    //     currencyCode: defaultCurrency);
  }

  @override
  Widget build(BuildContext context) {
    final groupId = FkManageProviders.get(context)['get-id'];
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];

    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();

    setState(() {
      retrieveMemberContribution =
          fetchMemberContribution(groupId: groupId, currencyCode: setCurrency);
    });
    return Container(
        child: FkContentBoxWidgets.body(context, 'groupe detail', itemList: [
      Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        PagesGenerator.goTo(context, pathName: "/groupe");
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                    Text(
                      "$screenTitle",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => PagesGenerator.goTo(context,
                          name: "add-contribution"),
                      icon: const Icon(
                        Icons.add_circle,
                        color: fkBlueText,
                      ),
                    ),
                    IconButton(
                      onPressed: () => PagesGenerator.goTo(context,
                          name: "invite-friend-to-group"),
                      icon: const Icon(
                        FontAwesomeIcons.paperPlane,
                        color: fkBlueText,
                        size: 18,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<GroupData>>(
              future: retrieveMemberContribution,
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
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification? overscroll) {
                        overscroll!.disallowIndicator();
                        return true;
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ContributionDetailsListTile(data: {
                            "id": "${snapshot.data?[index].id}",
                            "amount": "${snapshot.data?[index].amount}",
                            "name":
                                "${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}"
                          });
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
        ],
      ),
      const CustomDraggableSheet()
    ]));
  }
}
