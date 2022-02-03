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

// Repport card

Widget reportCard({leadingText, currency, amount, titleTxt, bdTxt, fn}) {
  return Container(
    child: Card(
      child: ExpansionTile(
        leading: Container(
          height: 80.0,
          width: 80.0,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fkDefaultColor,
          ),
          child: Column(
            children: [
              Icon(
                Icons.calendar_today,
                color: fkGreyText,
                size: 15,
              ),
              Text(leadingText,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20))
            ],
          ),
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
        controlAffinity: ListTileControlAffinity.leading,
        trailing: Icon(Icons.arrow_drop_down),
        children: <Widget>[
          ListTile(title: Text('$bdTxt')),
        ],
      ),
    ),
  );
}
