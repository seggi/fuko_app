import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class CustomExpandedListTile extends StatefulWidget {
  final Map data;
  CustomExpandedListTile({Key? key, required this.data}) : super(key: key);

  @override
  State<CustomExpandedListTile> createState() => _CustomExpandedListTileState();
}

class _CustomExpandedListTileState extends State<CustomExpandedListTile> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    final Map datas = widget.data;
    return Card(
      elevation: 2.0,
      child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      datas["month"],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: fkBlueText),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          datas["currency"],
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: fkGreyText),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          datas["totalAmount"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: fkBlackText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              verticalSpaceRegular,
              expandedListTile(data: datas)
            ],
          )),
    );
  }

  Widget expandedListTile({data}) {
    return ExpansionTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text(
        "Details",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: fkBlackText),
      ),
      trailing: Icon(
        _customTileExpanded
            ? Icons.arrow_drop_down_circle
            : Icons.arrow_drop_down,
      ),
      children: <Widget>[
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 35,
              height: 35,
              padding: EdgeInsets.all(8.0),
              color: fkBlueText,
              child: FittedBox(
                  child: Text(data['date'],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 24))),
            ),
          ),
          title: Column(
            children: [
              Row(
                children: [
                  Text(
                    data['currency'],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: fkGreyText),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    data['amount'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: fkBlackText),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Text(data["description"]),
              verticalSpaceSmall,
            ],
          ),
        ),
        Divider(
          thickness: 1,
        ),
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 35,
              height: 35,
              padding: EdgeInsets.all(8.0),
              color: fkBlueText,
              child: FittedBox(
                  child: Text("05",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 24))),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    data['currency'],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: fkGreyText),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "500",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: fkBlackText),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Text("By milk one pack"),
              verticalSpaceSmall,
            ],
          ),
        ),
      ],
      onExpansionChanged: (bool expanded) {
        setState(() => _customTileExpanded = expanded);
      },
    );
  }
}
