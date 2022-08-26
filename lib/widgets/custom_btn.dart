import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';

Widget authButton({context, title, btnColor, textColor, loading, fn}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
    decoration: title == "Login"
        ? BoxDecoration(
            color: btnColor, borderRadius: BorderRadius.circular(8.0))
        : BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: ftBtnColorBgSolid, width: 2.0)),
    child: TextButton(
        child: title == "Login"
            ? loading == false
                ? Text(
                    title,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0),
                  )
                : const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: fkWhiteText,
                    ),
                  )
            : Text(
                title,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0),
              ),
        onPressed: fn),
  );
}

// Textutton
Widget customTextButton(context, {btnTxt, fn}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        color: fkDefaultColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ftBtnColorBgSolid, width: 2.0)),
    child: TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.all(8.0),
          primary: fkDefaultColor,
          textStyle: const TextStyle(fontSize: 20)),
      onPressed: fn,
      child: Text(btnTxt,
          style: const TextStyle(
              color: fkWhiteText, fontWeight: FontWeight.w600, fontSize: 20.0)),
    ),
  );
}
