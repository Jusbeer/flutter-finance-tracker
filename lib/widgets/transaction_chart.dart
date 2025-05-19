import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TransactionChart extends StatelessWidget {
  final List<Map<String, dynamic>> recentTransactions;

  TransactionChart(this.recentTransactions);

  List<BarChartGroupData> get groupedBarData {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var tx in recentTransactions) {
        if (tx['date'].day == weekDay.day &&
            tx['date'].month == weekDay.month &&
            tx['date'].year == weekDay.year) {
          totalSum += tx['amount'];
        }
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalSum,
            color: Colors.indigo,
            width: 16,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).reversed.toList(); // recent days first
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Spending', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'Rs ${recentTransactions.fold(0.0, (sum, item) => sum + item['amount']).toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.indigo),
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final day = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                          return Text(DateFormat.E().format(day));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: groupedBarData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
