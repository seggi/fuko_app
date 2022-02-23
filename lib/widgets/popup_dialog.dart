import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

void showDialogWithFields(context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: const Text('Add Expenses'),
        content: SizedBox(
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
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: 'description',
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: fkInputFormBorderColor, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0))),
                  onSaved: (String? value) {},
                ),
                verticalSpaceMedium,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        width: 2.0,
                        color: fkDefaultColor,
                      )),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(300, 50)),
                    child: TextButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.add,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
