import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({Key? key, required this.expense}) : super(key: key);

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    // Determine the category label: if "others", use customCategory if provided.
    final categoryLabel = expense.category == Category.others &&
        expense.customCategory != null &&
        expense.customCategory!.isNotEmpty
        ? expense.customCategory
        : expense.category.name.toUpperCase();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expense Title
            Text(expense.title,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            // Expense Amount and Date
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Text(expense.formattedDate),
              ],
            ),
            const SizedBox(height: 8),
            // Payment Method (if provided)
            if (expense.paymentMethod != null &&
                expense.paymentMethod!.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.payment, size: 16),
                  const SizedBox(width: 4),
                  Text(expense.paymentMethod!),
                ],
              ),
            const SizedBox(height: 8),
            // Additional info for Friends category
            if (expense.category == Category.friends &&
                expense.friendNames != null &&
                expense.friendNames!.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.group, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text('Friends: ${expense.friendNames!.join(", ")}'),
                  ),
                ],
              ),
            // Final Category Label
            Row(
              children: [
                const Icon(Icons.label, size: 16),
                const SizedBox(width: 4),
                Text(categoryLabel!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
