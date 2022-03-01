import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class BudgetDetails extends StatefulWidget {
  final String title;

  const BudgetDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<BudgetDetails> createState() => _BudgetDetailsState();
}

class _BudgetDetailsState extends State<BudgetDetails> {
  @override
  Widget build(BuildContext context) {
    return FkScrollViewWidgets.body(context, itemList: [
      Container(
        padding: const EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () => PagesGenerator.goTo(context,
                              pathName: "/budget")),
                      Text(
                        widget.title,
                        style: const TextStyle(
                            color: fkBlueText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
            verticalSpaceRegular,
            Column(
              children: [
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Total Amount",
                    style: TextStyle(
                        color: fkGreyText,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
                Row(
                  children: const [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Rwf",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: fkBlackText),
                      ),
                    ),
                    horizontalSpaceTiny,
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "270,000",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: fkBlackText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            verticalSpaceRegular,
            Column(
              children: [
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "These operations must go ",
                    style: TextStyle(
                        color: fkGreyText,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: const [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "From",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: fkBlackText),
                          ),
                        ),
                        horizontalSpaceTiny,
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "12/02/2022",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: fkBlackText),
                          ),
                        ),
                      ],
                    ),
                    horizontalSpaceSmall,
                    Row(
                      children: const [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "to",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: fkBlackText),
                          ),
                        ),
                        horizontalSpaceTiny,
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "12/02/2022",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: fkBlackText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            verticalSpaceRegular,
            const Divider(
              color: fkGreyText,
            ),
            verticalSpaceRegular,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Amount",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            verticalSpaceRegular,
            const Expanded(
              child: Center(
                child: Text("No data to show currently"),
              ),
            )
          ],
        ),
      )
    ]);
  }
}
