import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

final DateFormat formatter = DateFormat.yMMMd();

const List<String> paymentMethods = [
  'Debit Card',
  'Cash',
  'Paytm Scanner',
  'PhonePe Scanner',
  'PhonePe App',
  'Paytm',
  'Google Pay',
  'Amazon Pay',
];

class NewExpense extends StatefulWidget {
  const NewExpense({required this.onAddExpense, super.key});

  final Function(Expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.lunch;
  final _customCategoryController = TextEditingController();
  final _friendNamesController = TextEditingController(); // Comma separated friend names

  // Payment method state variable
  String _selectedPaymentMethod = paymentMethods[0];

  @override
  void initState() {
    super.initState();
    // Set default date to today
    _selectedDate = DateTime.now();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter a valid title, amount, date, and select a category.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }
    List<String>? friendNames;
    if (_selectedCategory == Category.friends) {
      friendNames = _friendNamesController.text
          .split(',')
          .map((name) => name.trim())
          .where((name) => name.isNotEmpty)
          .toList();
    }
    String? customCategory;
    if (_selectedCategory == Category.others) {
      customCategory = _customCategoryController.text.trim();
    }
    print("THE AMOUNT ENTERED $enteredAmount");
    final expense = Expense(
      amount: enteredAmount,
      date: _selectedDate!,
      title: _titleController.text,
      category: _selectedCategory,
      paymentMethod: _selectedPaymentMethod, // Use the selected payment method
      friendNames: friendNames,
      customCategory: customCategory,
    );
    widget.onAddExpense(expense);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _customCategoryController.dispose();
    _friendNamesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 48),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: 'INR ',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formatter.format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Category Dropdown
            Row(
              children: [
                const Text('Category: '),
                const SizedBox(width: 16),
                DropdownButton<Category>(
                  value: _selectedCategory,
                  items: Category.values
                      .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name.toUpperCase()),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Payment Method Dropdown
            Row(
              children: [
                const Text('Payment Method: '),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedPaymentMethod,
                  items: paymentMethods
                      .map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedCategory == Category.friends) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _friendNamesController,
                decoration: const InputDecoration(
                  labelText: 'Friend Names (comma separated)',
                ),
              ),
            ],
            if (_selectedCategory == Category.others) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _customCategoryController,
                decoration: const InputDecoration(
                  labelText: 'Custom Category Name',
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text('Save Expense'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
