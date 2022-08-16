import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/notebook.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class NotebookMember extends StatefulWidget {
  final String id;
  const NotebookMember({Key? key, required this.id}) : super(key: key);

  @override
  State<NotebookMember> createState() => _NotebookMemberState();
}

class _NotebookMemberState extends State<NotebookMember> {
  bool loading1 = false;
  bool loading = false;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();

  late Future<List<Notebook>> retrieveNotebookMember;

  @override
  void initState() {
    super.initState();
    retrieveNotebookMember = fetchNotebookMember(notebookId: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final notebookId = widget.id;
    final screenTitle = FkManageProviders.get(context)['get-screen-title'];

    setState(() {
      retrieveNotebookMember = fetchNotebookMember(notebookId: widget.id);
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
                          PagesGenerator.goTo(context, pathName: "/notebook"),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )),
                  Text(
                    screenTitle,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () => PagesGenerator.goTo(context,
                          name: "invite-friend-to-notebook",
                          params: {"id": notebookId}),
                      icon: const Icon(
                        Icons.person_add_alt,
                        color: fkBlueText,
                      ))
                ],
              )
            ],
          )),
      fkContentBoxWidgets.initialItems(itemList: [
        verticalSpaceRegular,
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "All members",
            style: TextStyle(
                color: fkGreyText, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        verticalSpaceRegular,
      ]),
      Expanded(
        child: FutureBuilder(
          future: retrieveNotebookMember,
          builder: (context, AsyncSnapshot<List<Notebook>> snapshot) {
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

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const Icon(
                          Icons.account_circle_outlined,
                          size: 30,
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
                        subtitle: Column(children: [
                          verticalSpaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              loading == false
                                  ? InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.add_link,
                                              color: Colors.blue,
                                            ),
                                            horizontalSpaceSmall,
                                            Text("Dept")
                                          ],
                                        ),
                                      ),
                                      onLongPress: () => connect(
                                          notebookMemberId:
                                              '${snapshot.data?[index].id}',
                                          requestStatus: 2),
                                    )
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(left: 40.0),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                    ),
                              loading1 == false
                                  ? InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.add_link,
                                              color: Colors.blue,
                                            ),
                                            horizontalSpaceSmall,
                                            Text("Loan")
                                          ],
                                        ),
                                      ),
                                      onLongPress: () => reject(
                                          notebookMemberId:
                                              '${snapshot.data?[index].id}',
                                          requestStatus: 3))
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      margin:
                                          const EdgeInsets.only(right: 40.0),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                    )
                            ],
                          )
                        ]),
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

  connect({required String notebookMemberId, required int requestStatus}) {}

  reject({required String notebookMemberId, required int requestStatus}) {}
}
