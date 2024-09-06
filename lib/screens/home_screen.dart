import 'package:debtpayoff/screens/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/debt.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late Box<Debt> debtBox;

  @override
  void initState() {
    super.initState();
    debtBox = Hive.box<Debt>('debts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProgressScreen()));
              },
              icon: Icon(Icons.pie_chart_outline))
        ],
        backgroundColor: Colors.blue,
        title: Text(
          'Debt Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: debtBox.listenable(),
        builder: (context, Box<Debt> box, _) {
          final debts = box.values.toList().cast<Debt>();

          if (debts.isEmpty) {
            return Center(
              child: Text('No debts added yet.'),
            );
          }

          return ListView.builder(
            itemCount: debts.length,
            itemBuilder: (context, index) {
              final debt = debts[index];

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: ListTile(
                    title: Text(debt.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount: \Rs ${debt.amount.toStringAsFixed(2)} '),
                        Text('Due Date: ${debt.dueDate.day}' +
                            '/'
                                '${debt.dueDate.month}' +
                            '/'
                                '${debt.dueDate.year}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _databaseService.deleteDebt(index);
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/debt-detail',
                        arguments: debt,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-debt');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
