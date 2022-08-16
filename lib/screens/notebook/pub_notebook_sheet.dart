import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/notebook.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/bottom_sheet/currenncies.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class PubNotebookSheet extends StatefulWidget {
  const PubNotebookSheet({Key? key}) : super(key: key);

  @override
  State<PubNotebookSheet> createState() => _PubNotebookSheetState();
}

class _PubNotebookSheetState extends State<PubNotebookSheet> {
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();
  late Future<List<Notebook>> retrieveNotebook;

  @override
  void initState() {
    super.initState();
    retrieveNotebook = fetchNotebook();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle = FkManageProviders.save["save-screen-title"];

    setState(() {
      retrieveNotebook = fetchNotebook();
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        verticalSpaceSmall,
        SizedBox(
          height: MediaQuery.of(context).size.height - 290,
          child: FutureBuilder(
            future: retrieveNotebook,
            builder: (context, AsyncSnapshot<List<Notebook>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(0.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No data to show.'),
                      );
                    }
                    return InkWell(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.people_outline_outlined,
                            size: 30,
                          ),
                          title: SizedBox(
                            width: 200,
                            child: Text(
                              snapshot.data![index].name ?? 'No name provided',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          trailing: const Icon(Icons.more_vert),
                        ),
                      ),
                      onTap: () {
                        screenTitle(context,
                            screenTitle: "${snapshot.data?[index].name}");
                        PagesGenerator.goTo(context,
                            name: "notebook-member",
                            params: {"id": "${snapshot.data?[index].id}"});
                      },
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
      ],
    );
  }
}
