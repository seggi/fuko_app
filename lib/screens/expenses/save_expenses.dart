import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class SaveExpenses extends StatelessWidget {
  const SaveExpenses({Key? key}) : super(key: key);

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
                  child: Stack(
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
                  Positioned(
                    width: 350,
                    bottom: 40.0,
                    child: Container(
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
                  )
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
                  child: const Text(
                    "Add",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: fkWhiteText),
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogWithFields(context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text('Add Expenses'),
          content: SizedBox(
            height: 450,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: 'Amount',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: fkInputFormBorderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0))),
                    onSaved: (String? value) {},
                  ),
                  verticalSpaceRegular,
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: fkInputFormBorderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0))),
                    onSaved: (String? value) {},
                  ),
                  verticalSpaceRegular,
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    decoration: InputDecoration(
                        hintText: 'description',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: fkInputFormBorderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0))),
                    onSaved: (String? value) {},
                  ),
                  verticalSpaceMedium,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: fkBlueText,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tight(const Size(300, 50)),
                        child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                color: fkWhiteText,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     child: const Text('Cancel'),
          //   ),
          // ],
        );
      },
    );
  }
}
