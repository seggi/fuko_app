import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/manage_provider.dart';
import 'package:fuko_app/core/user_preferences.dart';
import 'package:fuko_app/utils/constant.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

void showDialogWithFields(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return const AlertDialog(
        insetPadding: EdgeInsets.all(10.0),
        title: Text('Register Saving'),
        contentPadding: EdgeInsets.all(10.0),
        content: RegisterSaving(),
      );
    },
  );
}

class RegisterSaving extends StatefulWidget {
  const RegisterSaving({Key? key}) : super(key: key);

  @override
  State<RegisterSaving> createState() => _RegisterSavingState();
}

class _RegisterSavingState extends State<RegisterSaving> {
  final _formKey = GlobalKey();

  TextEditingController amountController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  Future registerSaving() async {
    FocusManager.instance.primaryFocus?.unfocus();

    var selectedCurrency = FkManageProviders.get(context)["get-currency"];

    Map newItem = {
      "amount": amountController.text,
      "description": descriptionController.text,
      "currency_id": selectedCurrency != "" ? selectedCurrency : ""
    };

    if (amountController.text == "" || descriptionController.text == "") {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
        "Please fill all fields.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      )));
      return;
    } else {
      FkManageProviders.save['save-saving-amount'](context,
          itemData: double.parse(amountController.text));
      FkManageProviders.save["register-saving"](context, itemData: newItem);

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
                      onPressed: registerSaving,
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
