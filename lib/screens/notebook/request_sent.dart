import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/notebook.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';
import 'package:fuko_app/widgets/show_modal_bottom_sheet.dart';

class RequestSent extends StatefulWidget {
  const RequestSent({Key? key}) : super(key: key);

  @override
  State<RequestSent> createState() => _RequestSentState();
}

class _RequestSentState extends State<RequestSent> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<Notebook>> notebookRequestSent;

  @override
  void initState() {
    super.initState();
    notebookRequestSent = fetchRequestSent();
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
                  "Request sent",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              children: const [],
            )
          ],
        ),
      ),
      Expanded(
        child: FutureBuilder(
          future: notebookRequestSent,
          builder: (context, AsyncSnapshot<List<Notebook>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No pending request.'),
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
                      child: Text('No pending request.'),
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
                                text: 'You sent a request to ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '${snapshot.data?[index].username} ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(text: 'to join '),
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
                            const Text("Sent at "),
                            Text(
                                "${dateTime.year}-${dateTime.month}-${dateTime.day}")
                          ]),
                        ),
                        trailing: InkWell(
                          child: const Icon(Icons.more),
                          onTap: () => notebookCustomBottomModalSheet(context,
                              notebookMemberId: '${snapshot.data?[index].id}'),
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
