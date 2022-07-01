import 'package:flutter/material.dart';
import 'package:fuko_app/controllers/page_generator.dart';
import 'package:fuko_app/widgets/expanded_listtile.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

Widget homeCard({leadingIcon, currency, amount, titleTxt, fn}) {
  return InkWell(
    onTap: fn,
    child: Card(
      elevation: 0.0,
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
      ),
    ),
  );
}

// Repport card

Widget reportCard(context,
    {monthText, leadingText, currency, amount, titleTxt, String? bdTxt, fn}) {
  return Card(
    child: bdTxt == null
        ? ExpansionTile(
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
                        style:
                            const TextStyle(fontSize: 15, color: fkWhiteText),
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
                    color: fkBlackText,
                    fontWeight: FontWeight.w400,
                    fontSize: 18)),
            controlAffinity: ListTileControlAffinity.leading,
            trailing: const Icon(Icons.arrow_drop_down),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () =>
                          PagesGenerator.goTo(context, name: "dept-payment"),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.payments_sharp,
                            color: Colors.deepOrange,
                          ),
                          horizontalSpaceSmall,
                          Text("Pay")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
            ],
          )
        : ListTile(
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
                        style:
                            const TextStyle(fontSize: 15, color: fkWhiteText),
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
                    color: fkBlackText,
                    fontWeight: FontWeight.w400,
                    fontSize: 18)),
          ),
  );
}
