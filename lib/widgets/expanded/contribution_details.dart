import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/group.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class ContributionDetailsListTile extends StatefulWidget {
  final Map? data;
  const ContributionDetailsListTile({Key? key, this.data}) : super(key: key);

  @override
  State<ContributionDetailsListTile> createState() =>
      _ContributionDetailsListTileState();
}

class _ContributionDetailsListTileState
    extends State<ContributionDetailsListTile> {
  bool _customTileExpanded = false;

  late Future<List<GroupData>> retrieveParticipator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveParticipator = fetchParticipator(
        contributionId: widget.data!['id'], currencyCode: defaultCurrency);
  }

  @override
  Widget build(BuildContext context) {
    final Map? contributors = widget.data;
    var dateTime = DateTime.parse("${contributors!["created_at"]}");
    return Card(
      elevation: 2.0,
      child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      width: 35,
                      height: 35,
                      padding: const EdgeInsets.all(8.0),
                      color: fkBlueText,
                      child: FittedBox(
                          child: Text(
                              "${dateTime.day >= 10 ? dateTime.day : '0${dateTime.day}'}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24))),
                    ),
                  ),
                  title: Text(
                    "${contributors["description"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    "Added by ➤ ${contributors["name"]}",
                  ),
                  trailing: Text(
                    contributors["amount"],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: fkBlackText),
                  ),
                ),
              ),
              expandedListTile(data: contributors)
            ],
          )),
    );
  }

  Widget expandedListTile({data}) {
    var selectedCurrency =
        FkManageProviders.get(context)["get-default-currency"];
    var setCurrency =
        selectedCurrency != '' ? selectedCurrency : defaultCurrency.toString();
    return ExpansionTile(
      leading: const Icon(
        Icons.safety_divider,
        size: 30,
      ),
      title: const Text(
        "Splitter",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: fkBlackText),
      ),
      trailing: Icon(
        _customTileExpanded
            ? Icons.arrow_drop_down_circle
            : Icons.arrow_drop_down_circle_outlined,
      ),
      children: <Widget>[
        SizedBox(
          child: FutureBuilder(
              future: retrieveParticipator,
              builder: (context, AsyncSnapshot<List<GroupData>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No pending request.'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No pending request.'),
                        );
                      }
                      return ListTile(
                        leading: const Icon(Icons.person_pin),
                        title: Text("${snapshot.data?[index].username}"),
                        trailing: Text(
                          double.parse("${snapshot.data?[index].amount}")
                              .toStringAsFixed(1),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: fkBlackText),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong :('));
                }

                return Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const Center(
                    child: Text("Loading..."),
                  ),
                );
              }),
        )
      ],
      onExpansionChanged: (bool expanded) {
        setState(() {
          retrieveParticipator = fetchParticipator(
              contributionId: data!['id'], currencyCode: setCurrency);
        });
        setState(() => _customTileExpanded = expanded);
      },
    );
  }
}
