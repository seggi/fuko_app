import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';

Widget usernameFormField({usernameController = ""}) {
  return Container(
      child: TextFormField(
    controller: usernameController,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      hintText: 'Username',
      suffixIcon: Icon(Icons.account_circle, color: fkDefaultColor),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: fkInputFormBorderColor, width: 1.0),
          borderRadius: BorderRadius.circular(8.0)),
    ),
  ));
}

Widget reppeatFormField({reppeatPasswordController = ""}) {
  return Container(
    child: TextFormField(
      controller: reppeatPasswordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          hintText: 'Reppeat password',
          suffixIcon: Icon(Icons.password, color: fkDefaultColor),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: fkInputFormBorderColor, width: 1.0),
              borderRadius: BorderRadius.circular(8.0))),
    ),
  );
}
