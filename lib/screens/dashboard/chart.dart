import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SubscriberChart extends StatelessWidget {
  final List<StockGlobalReport> data;

  // ignore: use_key_in_widget_constructors
  const SubscriberChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<StockGlobalReport, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (StockGlobalReport series, _) => series.category,
          measureFn: (StockGlobalReport series, _) => series.amount,
          colorFn: (StockGlobalReport series, _) => series.barColor),
    ];

    return SizedBox(
      height: 500,
      child: Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Chart report",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Expanded(
                  child: SizedBox(
                child: charts.BarChart(series,
                    animate: true, behaviors: [charts.SeriesLegend()]),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors, must_be_immutable
class ChartReport extends StatefulWidget {
  final String expenses;
  final String savings;
  final String loan;
  final String dept;

  const ChartReport({
    Key? key,
    required this.expenses,
    required this.savings,
    required this.loan,
    required this.dept,
  }) : super(key: key);

  @override
  State<ChartReport> createState() => _ChartReportState();
}

class _ChartReportState extends State<ChartReport> {
  @override
  Widget build(BuildContext context) {
    final int dept = int.parse(widget.dept);
    final int savings = int.parse(widget.savings);
    final int loan = int.parse(widget.loan);
    final int expenses = int.parse(widget.expenses);

    final List<StockGlobalReport> data = [
      StockGlobalReport(
        category: "Expense",
        amount: expenses,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      StockGlobalReport(
        category: "Saving",
        amount: savings,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueGrey),
      ),
      StockGlobalReport(
        category: "Dept",
        amount: dept,
        barColor: charts.ColorUtil.fromDartColor(Colors.red),
      ),
      StockGlobalReport(
        category: "loan",
        amount: loan,
        barColor: charts.ColorUtil.fromDartColor(Colors.lightBlue),
      ),
    ];
    return SubscriberChart(data: data);
  }
}

class StockGlobalReport {
  final String category;
  final int amount;
  final charts.Color barColor;

  StockGlobalReport(
      {required this.category, required this.amount, required this.barColor});
}
