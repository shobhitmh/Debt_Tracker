import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/debt.dart';
import '../services/database_service.dart';

class DebtDetailScreen extends StatefulWidget {
  @override
  _DebtDetailScreenState createState() => _DebtDetailScreenState();
}

class _DebtDetailScreenState extends State<DebtDetailScreen> {
  final _repaymentController = TextEditingController();
  late Debt debt;

  final DatabaseService _databaseService = DatabaseService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Debt) {
      debt = args;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to retrieve debt details')),
      );
      Navigator.pop(context);
    }
  }

  void _repayDebt() {
    final repaymentAmount = double.tryParse(_repaymentController.text);
    if (repaymentAmount == null || repaymentAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid repayment amount.')),
      );
      return;
    }

    setState(() {
      debt.amount -= repaymentAmount;
      if (debt.amount < 0) {
        debt.amount = 0;
      }
    });

    final debtBox = Hive.box<Debt>('debts');
    final index = debtBox.values.toList().indexOf(debt);
    _databaseService.updateDebt(index, debt);

    _repaymentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Repayment of \Rs. ${repaymentAmount.toStringAsFixed(2)} made successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (debt == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Debt Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Text('No debt details available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Debt Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${debt.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Amount: \Rs. ${debt.amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Text('Due Date: ${debt.dueDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(fontSize: 18)),
            Divider(height: 40),
            TextField(
              controller: _repaymentController,
              decoration: InputDecoration(
                labelText: 'Repayment Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _repayDebt,
                  child: Text(
                    'Repay amount',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
