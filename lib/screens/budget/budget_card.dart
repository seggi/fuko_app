// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';

class BudgetBoxCard extends StatelessWidget {
  final String? amount;
  final String? currency;
  final String? endDate;
  final String? startDate;
  final String? createdAt;
  final String? title;
  var fn;

  BudgetBoxCard(
      {Key? key,
      this.title,
      this.startDate,
      this.endDate,
      this.amount,
      this.createdAt,
      this.currency,
      this.fn})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    createdAt ?? "",
                    style: const TextStyle(
                        color: fkGreyText,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    onPressed: fn,
                    icon: const Icon(
                      Icons.arrow_right_alt_rounded,
                      color: fkBlueText,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
