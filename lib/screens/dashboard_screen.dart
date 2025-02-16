import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../widgets/expense_item.dart';
import '../widgets/expenses_list.dart';
import 'new_expense.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _incomeBalance = 0.0;
  List<Expense> _expenses = [];



  // Compute top 3 expense types (excluding rent)
  List<ExpenseBucket> get topExpenseBuckets {
    final buckets = Category.values
        .map((cat) => ExpenseBucket.forCategory(_expenses, cat))
        .toList();
    // Exclude homeRent if needed
    buckets.removeWhere((bucket) => bucket.category == Category.homeRent);
    buckets.sort((a, b) => b.totalExpenses.compareTo(a.totalExpenses));
    return buckets.take(3).toList();
  }

  // Compute top 3 payment methods usage
  List<MapEntry<String, int>> get topPaymentMethods {
    final Map<String, int> methodCount = {};
    for (final expense in _expenses) {
      if (expense.paymentMethod != null && expense.paymentMethod!.isNotEmpty) {
        methodCount.update(expense.paymentMethod!, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    final sorted = methodCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).toList();
  }

  // Dummy function to simulate adding income
  void _addIncome() async {
    setState(() {
      _incomeBalance += 5000.0;
    });
    final incomeBox = Hive.box<double>('incomeBox');
    incomeBox.put('balance', _incomeBalance);
  }

  // Open the Add Expense modal.
  void _openAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  // When a new expense is added:
  void _addExpense(Expense expense) {

    print("AFTER ADDING EXPNESE THE AMOUNT ${expense.amount}");
    final expensesBox = Hive.box<Expense>('expensesBox');
    expensesBox.add(expense);
      _incomeBalance -= expense.amount;
      print("AFTER ADDING EXPNESE THE REMAINING AMOUNT ${_incomeBalance}");
    final incomeBox = Hive.box<double>('incomeBox');
    incomeBox.put('balance', _incomeBalance);
    setState(() {});
  }

  // Remove an expense, update income balance, and show Undo.
  void _removeExpense(Expense expense) {
    final expenseIndex = _expenses.indexOf(expense);

      _expenses.remove(expense);
      _incomeBalance += expense.amount;

    final incomeBox = Hive.box<double>('incomeBox');
    incomeBox.put('balance', _incomeBalance);
    // Remove from Hive. If Expense extends HiveObject, you can call expense.delete();
    expense.delete();
    setState(() { });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {

              _expenses.insert(expenseIndex, expense);
              _incomeBalance -= expense.amount;

            incomeBox.put('balance', _incomeBalance);
            final expensesBox = Hive.box<Expense>('expensesBox');
            expensesBox.add(expense);
              setState(() {});
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Load income balance from Hive
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final incomeBox = Hive.box<double>('incomeBox');
      print("THE INITIAL AMOUT INIT STATE ${incomeBox.get('balance', defaultValue: 0.0)!} ");
      _incomeBalance = incomeBox.get('balance', defaultValue: 0.0)!;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: _addIncome,
            tooltip: 'Add More Balance',
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Expense>>(
        valueListenable: Hive.box<Expense>('expensesBox').listenable(),
        builder: (context, box, _) {
          _expenses = box.values.toList();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Remaining Balance Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Remaining Balance:',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text('INR ${_incomeBalance.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addIncome,
                        tooltip: 'Add More Balance',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Top 3 Expense Types Section
                  Text('Top 3 Expense Types',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topExpenseBuckets.length,
                      itemBuilder: (ctx, index) {
                        final bucket = topExpenseBuckets[index];
                        return Card(
                          margin: const EdgeInsets.only(right: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(categoryIcons[bucket.category]),
                                const SizedBox(height: 4),
                                Text(bucket.category.name.toUpperCase(),
                                    style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('INR ${bucket.totalExpenses.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Top 3 Payment Methods Section
                  Text('Top 3 Payment Methods',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topPaymentMethods.length,
                      itemBuilder: (ctx, index) {
                        final methodEntry = topPaymentMethods[index];
                        return Card(
                          margin: const EdgeInsets.only(right: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.payment),
                                const SizedBox(height: 4),
                                Text(methodEntry.key,
                                    style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('${methodEntry.value} times',
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Expense History Section
                  Text('Expense History',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 400,
                    child: _expenses.isEmpty
                        ? const Center(
                      child: Text("No expenses found. Add some!"),
                    )
                        : ExpensesList(expenses: _expenses, onRemoveExpense: _removeExpense),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseModal,
        child: const Icon(Icons.add),
        tooltip: 'Add Expense',
      ),
    );
  }
}
