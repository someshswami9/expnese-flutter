import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category {
  bajajEmi,
  homeRent,
  electricityBill,
  zomat,
  blinkit,
  zepto,
  outsideBreakfast,
  lunch,
  restaurant,
  petrol,
  servicing,
  mobileRecharge,
  wifiRecharge,
  dmart,
  grocery,
  frullatto,
  friends,
  others,
}

final Map<Category, IconData> categoryIcons = {
  Category.bajajEmi: Icons.credit_card,
  Category.homeRent: Icons.house,
  Category.electricityBill: Icons.electrical_services,
  Category.zomat: Icons.fastfood,
  Category.blinkit: Icons.shopping_bag,
  Category.zepto: Icons.shopping_cart,
  Category.outsideBreakfast: Icons.breakfast_dining,
  Category.lunch: Icons.lunch_dining,
  Category.restaurant: Icons.restaurant,
  Category.petrol: Icons.local_gas_station,
  Category.servicing: Icons.build,
  Category.mobileRecharge: Icons.phone_android,
  Category.wifiRecharge: Icons.wifi,
  Category.dmart: Icons.store,
  Category.grocery: Icons.local_grocery_store,
  Category.frullatto: Icons.coffee,
  Category.friends: Icons.group,
  Category.others: Icons.category,
};

class Expense {
  Expense({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
    this.paymentMethod, // Add this field
    this.friendNames,
    this.customCategory,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final String? paymentMethod; // New field for payment method
  final List<String>? friendNames;
  final String? customCategory;

  String get formattedDate => formatter.format(date);
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses =
  allExpenses.where((expense) => expense.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses => expenses.fold(0, (sum, exp) => sum + exp.amount);
}
