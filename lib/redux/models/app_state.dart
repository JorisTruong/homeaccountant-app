import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final String account;
  final TextEditingController transactionName;
  final String transactionAccount;
  final TextEditingController transactionDate;
  final bool transactionIsExpense;
  final int categoryIndex;
  final Map<String, dynamic> subcategory;
  final TextEditingController subcategoryText;
  final Icon subcategoryIcon;
  final TextEditingController transactionAmount;
  final TextEditingController transactionDescription;
  final String dateRange;
  final List<String> route;

  const AppState({
    @required this.account,
    this.transactionName,
    this.transactionAccount,
    this.transactionDate,
    this.transactionIsExpense,
    this.categoryIndex,
    this.subcategory,
    this.subcategoryText,
    this.subcategoryIcon,
    this.transactionAmount,
    this.transactionDescription,
    @required this.dateRange,
    @required this.route
  });

  @override
  String toString() {
    return 'AppState: {account: $account, categoryIndex: $categoryIndex, subcategory: $subcategory, dateRange: $dateRange, route: $route}';
  }
}