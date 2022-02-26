import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

void showDialogWithFields(context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: const Text('Add Expenses'),
        content: AddExpenses(),
      );
    },
  );
}

class AddExpenses extends StatefulWidget {
  AddExpenses({Key? key}) : super(key: key);

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final _formKey = GlobalKey();

  TextEditingController amountController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  saveExpenses() {
    Map newItem = {
      "amount": amountController.text,
      "description": descriptionController.text
    };

    if (amountController.text == "" && descriptionController.text == "") {
      return;
    } else {
      FkManageProviders.save['save-expenses-amount'](context,
          itemData: double.parse(amountController.text));
      FkManageProviders.save["add-expenses"](context, itemData: newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: amountController,
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
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'Description',
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
                      onPressed: saveExpenses,
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
  }
}
