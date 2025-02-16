import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _incomeController = TextEditingController();
  double? _income;
  final DateFormat _dateFormat = DateFormat.yMMM();

  void _saveIncome() {
    final enteredIncome = double.tryParse(_incomeController.text);
    if (enteredIncome == null || enteredIncome <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid income amount')),
      );
      return;
    }
    setState(() {
      _income = enteredIncome;
    });
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
            if (_income != null)
              Text(
                'Your income for $currentMonth is \$${_income!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
          ],
        ),
      ),
    );
  }
}
