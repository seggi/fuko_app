import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/expanded_listtile.dart';
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
                style: const TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w300,
                    fontSize: 11)),
            horizontalSpaceTiny,
            Text(amount,
                style: const TextStyle(
                    color: fkGreyText,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
          ],
        ),
        title: Text(titleTxt,
            style: const TextStyle(
                color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 18)),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz_rounded),
          onPressed: fn,
        ),
      ),
    ),
  );
}

// Repport card

Widget reportCard(
    {monthText, leadingText, currency, amount, titleTxt, String? bdTxt, fn}) {
  return Card(
    child: ExpansionTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          color: fkBlueText,
          child: FittedBox(
            child: Column(
              children: [
                Text(
                  monthText,
                  style: const TextStyle(fontSize: 15, color: fkWhiteText),
                ),
                Text(leadingText,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24))
              ],
            ),
          ),
        ),
      ),
      subtitle: Row(
        children: [
          Text(currency,
              style: const TextStyle(
                  color: fkGreyText,
                  fontWeight: FontWeight.w300,
                  fontSize: 11)),
          horizontalSpaceTiny,
          Text(amount,
              style: const TextStyle(
                  color: fkGreyText,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
        ],
      ),
      title: Text(titleTxt,
          style: const TextStyle(
              color: fkBlackText, fontWeight: FontWeight.w400, fontSize: 18)),
      controlAffinity: ListTileControlAffinity.leading,
      trailing: const Icon(Icons.arrow_drop_down),
      children: bdTxt == null
          ? <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "month",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: fkBlueText),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: const [
                        Text(
                          "currency",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: fkGreyText),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "totalAmount",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: fkBlackText),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ]
          : [ListTile(title: Text(bdTxt))],
    ),
  );
}
