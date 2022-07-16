import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

customBottomSheet(context, retrieveCurrencies, setCurrencyId) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            verticalSpaceSmall,
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Currencies",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                              child: Text("No expense saved yet!")));
                    }
                    return SizedBox(
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification? overscroll) {
                          overscroll!.disallowIndicator();
                          return true;
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                margin: const EdgeInsets.only(top: 0.0),
                                child: Card(
                                  child: ListTile(
                                    leading:
                                        const Icon(Icons.currency_exchange),
                                    title: Text(
                                        "${snapshot.data?[index].currencyCode}"),
                                    subtitle: Text(
                                        snapshot.data?[index].description ??
                                            "No description"),
                                    onTap: () => setCurrencyId(context,
                                        currencyId:
                                            snapshot.data?[index].currencyId),
                                  ),
                                ));
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong:('));
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
        );
      });
}
