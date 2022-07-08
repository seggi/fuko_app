import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../../controllers/page_generator.dart';

class CustomDraggableSheet extends StatefulWidget {
  const CustomDraggableSheet({Key? key}) : super(key: key);

  @override
  State<CustomDraggableSheet> createState() => _CustomDraggableSheetState();
}

class _CustomDraggableSheetState extends State<CustomDraggableSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: DraggableScrollableSheet(
            expand: true,
            initialChildSize: .1,
            minChildSize: .1,
            maxChildSize: .9,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 0.0,
                ),
                decoration: const BoxDecoration(
                    color: fkWhiteText,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: fkWhiteText, // changes position of shadow
                      ),
                    ]),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: fkDefaultColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            height: 5,
                            width: 40,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: fkWhiteText,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        Container(
                          color: fkDefaultColor,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.summarize,
                                      size: 20,
                                      color: fkWhiteText,
                                    ),
                                    Text(
                                      "Report",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: fkWhiteText),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        verticalSpaceSmall,
                        Container(
                          color: fkWhiteText,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => PagesGenerator.goTo(context,
                                    name: "groupe-detail"),
                                child: Container(
                                  height: 60,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: fkGreyText, width: 0.5))),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: fkGreyText,
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                      ),
                                      horizontalSpaceSmall,
                                      SizedBox(
                                        width: 100,
                                        height: 40,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text("Seggi"),
                                            Text("rwf 500")
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
