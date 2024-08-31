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

    // Calculate the total debt
    double totalDebt = debts.fold(0, (sum, debt) => sum + debt.amount);

    // Create PieChartSectionData list
    List<PieChartSectionData> sections = debts.map((debt) {
      double percentage = (debt.amount / totalDebt) * 100;

      return PieChartSectionData(
        value: percentage,
        title: '${debt.name}: ${percentage.toStringAsFixed(1)}%',
        color: _getColorForDebt(debt),
        radius: 100,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Debt Payoff Progress',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payoff Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 55,
                  sectionsSpace: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForDebt(Debt debt) {
    // Simple color logic based on remaining amount; adjust as needed
    if (debt.amount < 100) return Colors.blue;
    if (debt.amount < 500) return Colors.blue;
    return Colors.blue;
  }
}
