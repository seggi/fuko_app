import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../content_box_widgets.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({Key? key}) : super(key: key);

  @override
  _AddExpensesScreenState createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return FkAddDataFormBox.body(context, itemList: [
      Container(
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.bottomLeft,
        child: RichText(
          text: const TextSpan(
            text: 'Add Expenses',
            style: TextStyle(
                fontSize: 18, color: fkBlackText, fontWeight: FontWeight.w300),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: Form(
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              Form.of(primaryFocus!.context!)!.save();
            },
            child: Column(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(300, 50)),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.monetization_on),
                          hintText: 'Amount',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: fkInputFormBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      onSaved: (String? value) {},
                    )),
                verticalSpaceRegular,
                ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(300, 50)),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.title),
                          hintText: 'Title',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: fkInputFormBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      onSaved: (String? value) {},
                    )),
                verticalSpaceRegular,
                ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(300, 100)),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.description),
                          hintText: 'description',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: fkInputFormBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      onSaved: (String? value) {},
                    )),
                verticalSpaceMassive,
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
            )),
      ),
    ]);
  }
}
