import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/core/budget.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../../utils/constant.dart';

class SearchBudgetCategory extends StatefulWidget {
  const SearchBudgetCategory({Key? key}) : super(key: key);

  @override
  State<SearchBudgetCategory> createState() => _SearchBudgetCategoryState();
}

class _SearchBudgetCategoryState extends State<SearchBudgetCategory> {
  String searchString = " ";

  @override
  void initState() {
    super.initState();
    retrieveBudgetCategories = fetchBudgetCategories();
  }

  @override
  Widget build(BuildContext context) {
    final saveSelectedItem = FkManageProviders.save["save-select-item"];
    return FkScrollViewWidgets.body(context, itemList: [
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
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                    onPressed: () => PagesGenerator.goTo(
                      context,
                      name: "add-budget-details",
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(2.0),
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1.0),
                            borderRadius: BorderRadius.circular(4.0)),
                      ),
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          searchString = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceSmall,
            Expanded(
              child: FutureBuilder(
                future: retrieveBudgetCategories,
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isEmpty) {
                      return Container(
                          margin: const EdgeInsets.only(top: 0.0),
                          child:
                              const Center(child: Text("No budget to show!")));
                    }
                    return SizedBox(
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
                            return snapshot.data?[index].budgetCategory
                                    .toLowerCase()
                                    .contains(searchString)
                                ? Card(
                                    child: ListTile(
                                      leading: const Icon(Icons.category),
                                      title: Text(
                                          "${snapshot.data?[index].budgetCategory}"),
                                      subtitle: Text(
                                          snapshot.data?[index].description ??
                                              "No description"),
                                      onTap: () {
                                        saveSelectedItem(context, itemData: {
                                          "id": "${snapshot.data?[index].id}",
                                          "name":
                                              "${snapshot.data?[index].budgetCategory}"
                                        });

                                        PagesGenerator.goTo(
                                          context,
                                          name: "add-budget-details",
                                        );
                                      },
                                    ),
                                  )
                                : Container();
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
      )
    ]);
  }
}
