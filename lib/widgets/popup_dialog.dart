import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

void showDialogWithFields(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return const AlertDialog(
        insetPadding: EdgeInsets.all(10.0),
        title: Text('Add Expenses'),
        contentPadding: EdgeInsets.all(10.0),
        content: AddExpenses(),
      );
    },
  );
}

class AddExpenses extends StatefulWidget {
  const AddExpenses({Key? key}) : super(key: key);

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final _formKey = GlobalKey();

  TextEditingController amountController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future saveExpenses() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var userId = await UserPreferences.getUserId();
    Map newItem = {
      "amount": amountController.text,
      "description": descriptionController.text,
      "user_id": userId,
      "title": ""
    };

    if (amountController.text == "" || descriptionController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "Please fill all fields.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      FkManageProviders.save['save-expenses-amount'](context,
          itemData: double.parse(amountController.text));
      FkManageProviders.save["add-expenses"](context, itemData: newItem);

      Navigator.pop(context);
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
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                maxLines: 2,
                decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: fkInputFormBorderColor, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0))),
                onSaved: (String? value) {},
              ),
              verticalSpaceMedium,
              Row(
                children: [
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 2.0,
                          color: Colors.red,
                        )),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: fkDefaultColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 2.0,
                          color: fkDefaultColor,
                        )),
                    child: TextButton(
                      onPressed: saveExpenses,
                      child: const Icon(
                        Icons.add,
                        color: fkWhiteText,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showDialogWithCircularProgress(context) {
  showDialog(
    context: context,
    builder: (_) {
      return const AlertDialog(
          insetPadding: EdgeInsets.all(10.0),
          content: SizedBox(child: Text("Please wait")));
    },
  );
}

Future<void> waitingOption(context, {String? title}) async {
  showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
              content: SizedBox(
            height: 20,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
                horizontalSpaceRegular,
                Text(title!),
              ],
            )),
          )));
}
