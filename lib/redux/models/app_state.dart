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
  final int categorySubcategoryId;
  final TextEditingController categorySubcategoryText;
  final Icon categorySubcategoryIcon;
  final int transactionSubcategoryId;
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
    @required this.accountId,
    this.transactionName,
    this.transactionAccountId,
    this.transactionDate,
    this.transactionIsExpense,
    this.categoryIndex,
    this.categorySubcategoryId,
    this.categorySubcategoryText,
    this.categorySubcategoryIcon,
    this.transactionSubcategoryId,
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