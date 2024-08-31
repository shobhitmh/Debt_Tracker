import 'package:debtpayoff/screens/add_debt_screen.dart';
import 'package:debtpayoff/screens/debt_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/debt.dart';
import 'screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DebtAdapter());
  await Hive.openBox<Debt>('debts');
  runApp(DebtTrackerApp());
}

class DebtTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Debt Payoff Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/add-debt': (context) => AddDebtScreen(),
        '/debt-detail': (context) => DebtDetailScreen(),
      },
    );
  }
}
