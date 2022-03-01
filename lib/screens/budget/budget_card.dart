import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

class BudgetBoxCard extends StatelessWidget {
  final String amount;
  final String currency;
  final String endDate;
  final String startDate;
  final String title;
  Function fn;

  BudgetBoxCard(
      {Key? key,
      required this.title,
      required this.startDate,
      required this.endDate,
      required this.amount,
      required this.currency,
      required this.fn})
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Text(currency),
                      horizontalSpaceTiny,
                      Text(
                        amount,
                        style: const TextStyle(
                            color: fkBlueText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpaceRegular,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Period",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(startDate),
                          horizontalSpaceSmall,
                          const Text("-"),
                          horizontalSpaceSmall,
                          Text(endDate)
                        ],
                      ),
                      IconButton(
                          onPressed: fn(),
                          icon: const Icon(
                            Icons.arrow_right_alt_rounded,
                            color: Colors.deepOrange,
                          ))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
