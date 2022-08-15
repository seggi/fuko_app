import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/notebook.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class IncomingRequest extends StatefulWidget {
  const IncomingRequest({Key? key}) : super(key: key);

  @override
  State<IncomingRequest> createState() => _IncomingRequestState();
}

class _IncomingRequestState extends State<IncomingRequest> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<Notebook>> retrieveIncomingRequest;

  @override
  void initState() {
    super.initState();
    retrieveIncomingRequest = fetchIncomingRequest();
  }

  @override
  Widget build(BuildContext context) {
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
                          PagesGenerator.goTo(context, pathName: "/notebook"),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  const Text(
                    "Request received",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: const [],
              )
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        verticalSpaceRegular,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "All requests",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceRegular,
      ]),
      Expanded(
        child: FutureBuilder(
          future: retrieveIncomingRequest,
          builder: (context, AsyncSnapshot<List<Notebook>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No request found.'),
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
                      child: Text('No request found.'),
                    );
                  }
                  var dateTime =
                      DateTime.parse("${snapshot.data?[index].sentAt}");
                  return InkWell(
                    child: Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.message,
                          size: 30,
                          color: fkBlueText,
                        ),
                        title: SizedBox(
                            width: 200,
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '${snapshot.data?[index].username} ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(text: 'invited you to join '),
                                  TextSpan(
                                      text:
                                          '${snapshot.data?[index].notebookName} ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(text: 'notebook.')
                                ],
                              ),
                            )),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(children: [
                            const Text("Sent "),
                            Text(
                                "${dateTime.year}-${dateTime.month}-${dateTime.day}")
                          ]),
                        ),
                        trailing: const InkWell(child: Icon(Icons.more)),
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
