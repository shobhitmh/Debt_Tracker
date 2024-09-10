import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/debt.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final debtBox = Hive.box<Debt>('debts');
    final debts = debtBox.values.toList();

    if (debts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Debt Payoff Progress',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
            child: Text(
          'No debts to display progress.',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
      );
    }

    double maxDebt =
        debts.fold(0, (max, debt) => debt.amount > max ? debt.amount : max);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          'Debt Payoff Progress',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width:
                debts.length * 80.0, // Adjust width based on the number of bars
            child: BarChart(
              BarChartData(
                barGroups: debts.asMap().entries.map((entry) {
                  int index = entry.key;
                  Debt debt = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: debt.amount,
                        color: _getColorForDebt(debt),
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          color: Colors.grey[300],
                          toY: (maxDebt + maxDebt * 0.3),
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final debt = debts[value.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            debt.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8.0),
                    tooltipMargin: 8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForDebt(Debt debt) {
    if (debt.amount < 100) return Colors.blue;
    if (debt.amount < 500) return Colors.orange;
    return Colors.red;
  }
}
