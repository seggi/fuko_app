import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

Widget homeCard({leadingIcon, currency, amount, titleTxt, fn}) {
  return Container(
    child: Card(
      child: ListTile(
        leading: Icon(
          leadingIcon,
          color: fkDefaultColor,
        ),
        subtitle: Row(
          children: [
            Text(currency,
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w300,
                    fontSize: 11)),
            horizontalSpaceTiny,
            Text(amount,
                style: TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
          ],
        ),
        title: Text(titleTxt,
            style: TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 18)),
        trailing: IconButton(
          icon: Icon(Icons.more_horiz_rounded),
          onPressed: fn,
        ),
      ),
    ),
  );
}
