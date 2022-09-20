import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

import '../../controllers/manage_provider.dart';
import '../../core/currency_data.dart';
import '../../utils/constant.dart';

class CurrencyButtonSheet extends StatefulWidget {
  const CurrencyButtonSheet({Key? key}) : super(key: key);

  @override
  State<CurrencyButtonSheet> createState() => _CurrencyButtonSheetState();
}

class _CurrencyButtonSheetState extends State<CurrencyButtonSheet> {
  String searchString = " ";

  @override
  void initState() {
    super.initState();
    retrieveCurrencies = fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    final setCurrencyId = FkManageProviders.save["add-default-currency"];
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Column(
                  children: [
                    verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "Currencies",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.cancel_outlined))
                      ],
                    ),
                    verticalSpaceSmall,
                    Expanded(
                      child: FutureBuilder(
                        future: retrieveCurrencies,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot snapshot,
                        ) {
                          if (snapshot.hasData) {
                            if (snapshot.data.isEmpty) {
                              return Container(
                                  margin: const EdgeInsets.only(top: 0.0),
                                  child: const Center(
                                      child: Text("No currencies found!")));
                            }
                            return SizedBox(
                              child: NotificationListener<
                                  OverscrollIndicatorNotification>(
                                onNotification:
                                    (OverscrollIndicatorNotification?
                                        overscroll) {
                                  overscroll!.disallowIndicator();
                                  return true;
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      child: ListTile(
                                        leading:
                                            const Icon(Icons.currency_exchange),
                                        title: Text(
                                            "${snapshot.data?[index].currencyCode}"),
                                        subtitle: Text(
                                            snapshot.data?[index].description ??
                                                "No description"),
                                        onTap: () {
                                          setCurrencyId(context,
                                              currencyId: snapshot
                                                  .data?[index].currencyId);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong:('));
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            });
      },
      icon: const Icon(
        Icons.currency_exchange,
        size: 20,
        color: fkWhiteText,
      ),
    );
  }
}
