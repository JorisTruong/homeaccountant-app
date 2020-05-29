import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

@immutable
class AppState {
  final Database db;
  final int accountId;
  final TextEditingController transactionName;
  final int transactionAccountId;
  final TextEditingController transactionDate;
  final bool transactionIsExpense;
  final int categoryIndex;
  final TextEditingController categorySubcategoryText;
  final Icon categorySubcategoryIcon;
  final TextEditingController transactionSubcategoryText;
  final Icon transactionSubcategoryIcon;
  final TextEditingController transactionAmount;
  final TextEditingController transactionDescription;
  final String dateRangeType;
  final DateTime selectedDate;
  final Map<String, String> dateRange;
  final List<String> route;
  final bool visibility;
  final bool isCreating;
  final bool isSelectingSubcategory;

  AppState({
    this.db,
    @required this.accountId,
    this.transactionName,
    this.transactionAccountId,
    this.transactionDate,
    this.transactionIsExpense,
    this.categoryIndex,
    this.categorySubcategoryText,
    this.categorySubcategoryIcon,
    this.transactionSubcategoryText,
    this.transactionSubcategoryIcon,
    this.transactionAmount,
    this.transactionDescription,
    this.dateRangeType,
    this.selectedDate,
    @required this.dateRange,
    @required this.route,
    this.visibility,
    this.isCreating,
    this.isSelectingSubcategory,
  });

  @override
  String toString() {
    return 'AppState: {accountId: $accountId, categoryIndex: $categoryIndex, dateRange: $dateRange, route: $route}';
  }
}