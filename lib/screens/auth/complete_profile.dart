import 'package:flutter/material.dart';
import 'package:fuko_app/screens/content_box_widgets.dart';
import 'package:fuko_app/widgets/custom_btn.dart';
import 'package:fuko_app/widgets/other_input.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class CompleteProfile extends StatefulWidget {
  final String data;

  const CompleteProfile({Key? key, required this.data}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  bool isLoading = false;
  FkContentBoxWidgets fkContentBoxWidgets = FkContentBoxWidgets();
  final _formKey = GlobalKey();

  @override
  @override
  Widget build(BuildContext context) {
    final String username = widget.data;
    return FkContentBoxWidgets.body(context, "complete profile",
        widTxt: "complete profile",
        itemList: [
          fkContentBoxWidgets.initialItems(itemList: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                username,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: fkBlackText),
              ),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Welocome to FUKO, Please fill these fields bofre you start",
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w300,
                    fontSize: 14),
              ),
            )
          ]),
          FkContentBoxWidgets.buttonsItemsBox(context, itemList: [
            commonFormField(
                hintTxt: "Your First Name", inpIcon: Icons.perm_identity),
            verticalSpaceRegular,
            commonFormField(
                hintTxt: "Your Last Name", inpIcon: Icons.perm_identity),
            verticalSpaceRegular,
            commonFormField(hintTxt: "Your Phone Number", inpIcon: Icons.phone),
            verticalSpaceRegular,
            commonFormField(hintTxt: "Your Gender", inpIcon: Icons.female),
            verticalSpaceLarge,
            isLoading == false
                ? customTextButton(context, btnTxt: "Start", fn: () {})
                : const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
            verticalSpaceRegular,
          ])
        ]);
  }
}
