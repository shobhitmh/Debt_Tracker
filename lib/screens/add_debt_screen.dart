// lib/screens/add_debt_screen.dart

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:hive/hive.dart';
import '../models/debt.dart';
import '../services/database_service.dart';

class AddDebtScreen extends StatefulWidget {
  @override
  _AddDebtScreenState createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _minimumPaymentController = TextEditingController();
  final _dueDateController = TextEditingController(); // Added controller
  DateTime? _dueDate;
  final DatabaseService _databaseService = DatabaseService();

  void _selectDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && selectedDate != _dueDate) {
      setState(() {
        _dueDate = selectedDate;
        _dueDateController.text =
            '${_dueDate!.toLocal()}'.split(' ')[0]; // Update the controller
      });
    }
  }

  void _saveDebt() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    final interestRate = double.tryParse(_interestRateController.text) ?? 0.0;

    final name = _nameController.text;
    final minimumPayment =
        double.tryParse(_minimumPaymentController.text) ?? 0.0;
    final dueDate = _dueDate ?? DateTime.now();

    if (name.isEmpty || amount <= 0 || minimumPayment < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    final debt = Debt(
      name: name,
      amount: amount,
      interestRate: interestRate,
      minimumPayment: minimumPayment,
      dueDate: dueDate,
    );

    // Save the new debt to Hive
    _databaseService.addDebt(debt);

    // Go back to the home screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Add Debt',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Debt Name'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _selectDueDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dueDateController, // Set the controller here
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      hintText: 'Select a due date',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _saveDebt,
                    child: Text(
                      'Add Debt',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
