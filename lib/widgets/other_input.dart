import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';

Widget usernameFormField({usernameController = ""}) {
  return TextFormField(
    controller: usernameController,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      hintText: 'Username',
      suffixIcon: const Icon(Icons.account_circle, color: fkDefaultColor),
      border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: fkInputFormBorderColor, width: 1.0),
          borderRadius: BorderRadius.circular(8.0)),
    ),
  );
}

Widget reppeatFormField({reppeatPasswordController = ""}) {
  return TextFormField(
    controller: reppeatPasswordController,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
        hintText: 'Reppeat password',
        suffixIcon: const Icon(Icons.password, color: fkDefaultColor),
        border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: fkInputFormBorderColor, width: 1.0),
            borderRadius: BorderRadius.circular(8.0))),
  );
}

Widget birthDateFormField({birthDateController = ""}) {
  return TextFormField(
    controller: birthDateController,
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
        hintText: 'Birth date',
        suffixIcon:
            const Icon(Icons.calendar_today_sharp, color: fkDefaultColor),
        border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: fkInputFormBorderColor, width: 1.0),
            borderRadius: BorderRadius.circular(8.0))),
  );
}

Widget commonFormField({commonController, hintTxt, inpIcon, initialV}) {
  return TextFormField(
    controller: commonController,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      hintText: '$hintTxt',
      suffixIcon: Icon(inpIcon, color: fkDefaultColor),
      border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: fkInputFormBorderColor, width: 1.0),
          borderRadius: BorderRadius.circular(8.0)),
    ),
  );
}
