import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  AnalysisPage({required this.transactions});

  List<BarChartGroupData> get groupedBarData {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double total = 0.0;

      for (var tx in transactions) {
        final txDate = tx['date'] as DateTime;
        final isSameDay = txDate.day == weekDay.day &&
            txDate.month == weekDay.month &&
            txDate.year == weekDay.year;
        final isExpense = tx['type'] == 'expense';

        if (isSameDay && isExpense) {
          total += tx['amount'];
        }
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total,
            color: Colors.indigo,
            width: 16,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).reversed.toList();
  }

  double get totalSpending {
    return transactions
        .where((tx) => tx['type'] == 'expense')
        .fold(0.0, (sum, tx) => sum + tx['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spending Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: TextStyle(fontSize: 16)),
                    Text(
                      'Rs ${totalSpending.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final day = DateTime.now()
                                  .subtract(Duration(days: value.toInt()));
                              return Text(DateFormat.E().format(day).substring(0, 3));
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      barGroups: groupedBarData,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
