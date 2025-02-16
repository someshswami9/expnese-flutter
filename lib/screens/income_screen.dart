import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});
  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _incomeController = TextEditingController();
  double _income = 0.0; // Default to 0.0 if no income is stored
  final DateFormat _dateFormat = DateFormat.yMMM();

  @override
  void initState() {
    super.initState();
    // Retrieve stored income from Hive
    final incomeBox = Hive.box<double>('incomeBox');
    setState(() {
      _income = incomeBox.get('balance', defaultValue: 0.0) as double;
    });
  }

  void _saveIncome() {
    final enteredIncome = double.tryParse(_incomeController.text);
    if (enteredIncome == null || enteredIncome <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid income amount')),
      );
      return;
    }
    setState(() {
      _income += enteredIncome;
    });
    // Save the updated income to Hive
    final incomeBox = Hive.box<double>('incomeBox');
    incomeBox.put('balance', _income);
    _incomeController.clear();
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = _dateFormat.format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Income')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Set your income for $currentMonth',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Income Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIncome,
              child: const Text('Save Income'),
            ),
            const SizedBox(height: 20),
            Text(
              'Your income for $currentMonth is \$${_income.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
