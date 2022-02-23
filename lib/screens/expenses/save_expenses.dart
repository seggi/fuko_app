import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/widgets/popup_dialog.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class SaveExpenses extends StatelessWidget {
  SaveExpenses({Key? key}) : super(key: key);

  TextEditingController amountController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () =>
                          PagesGenerator.goTo(context, pathName: "/expenses")),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.save,
                        color: fkBlueText,
                        size: 28,
                      ))
                ],
              ),
              verticalSpaceRegular,
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Added Expenses",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              verticalSpaceRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Title",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Amount",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              verticalSpaceRegular,
              Expanded(
                  child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Agua"),
                          Text("2000"),
                        ],
                      ),
                      verticalSpaceRegular,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Frijoles"),
                          Text("8500"),
                        ],
                      ),
                    ],
                  ),
                  verticalSpaceLarge,
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: fkGreyText))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "10500",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
              Container(
                decoration: BoxDecoration(
                    color: fkDefaultColor,
                    borderRadius: BorderRadius.circular(8.0)),
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: TextButton(
                        onPressed: () => showDialogWithFields(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.data_saver_on,
                              color: fkWhiteText,
                            ),
                            horizontalSpaceSmall,
                            Text(
                              "New Item",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: fkWhiteText),
                            ),
                          ],
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
