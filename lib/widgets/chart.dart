import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, required this.expenses}) : super(key: key);

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    // Create a bucket for each category
    return Category.values.map((cat) => ExpenseBucket.forCategory(expenses, cat)).toList();
  }

  double get maxTotalExpense {
    return buckets.fold(0, (prev, bucket) =>
    bucket.totalExpenses > prev ? bucket.totalExpenses : prev);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: buckets.map((bucket) {
                // Optionally exclude "Home Rent" from the top 3 calculation in your dashboard logic.
                return ChartBar(
                  fill: bucket.totalExpenses == 0
                      ? 0
                      : bucket.totalExpenses / maxTotalExpense,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets.map((bucket) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    categoryIcons[bucket.category],
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
