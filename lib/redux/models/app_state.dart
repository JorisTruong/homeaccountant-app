import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final int accountId;
  final TextEditingController transactionName;
  final int transactionAccountId;
  final TextEditingController transactionDate;
  final bool transactionIsExpense;
  final int categoryIndex;
  final Map<String, dynamic> subcategory;
  final TextEditingController subcategoryText;
  final Icon subcategoryIcon;
  final TextEditingController transactionAmount;
  final TextEditingController transactionDescription;
  final String dateRangeType;
  final DateTime selectedDate;
  final Map<String, String> dateRange;
  final List<String> route;
  final bool visibility;
  final bool isCreating;

  AppState({
    @required this.accountId,
    this.transactionName,
    this.transactionAccountId,
    this.transactionDate,
    this.transactionIsExpense,
    this.categoryIndex,
    this.subcategory,
    this.subcategoryText,
    this.subcategoryIcon,
    this.transactionAmount,
    this.transactionDescription,
    this.dateRangeType,
    this.selectedDate,
    @required this.dateRange,
    @required this.route,
    this.visibility,
    this.isCreating,
  });

  @override
  String toString() {
    return 'AppState: {accountId: $accountId, categoryIndex: $categoryIndex, subcategory: $subcategory, dateRange: $dateRange, route: $route}';
  }
}