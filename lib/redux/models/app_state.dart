import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


@immutable
class AppState {
  final int accountId;
  final int transactionId;
  final int accountInfoId;
  final TextEditingController accountInfoName;
  final TextEditingController accountInfoAcronym;
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
  final String showTransactionType;
  final TextEditingController showTransactionDate;
  final bool visibility;
  final bool isCreatingAccount;
  final bool isCreatingTransaction;
  final bool isCreatingSubcategory;
  final bool isSelectingSubcategory;

  AppState({
    @required this.accountId,
    this.accountInfoId,
    this.accountInfoName,
    this.accountInfoAcronym,
    this.transactionId,
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
    this.showTransactionType,
    this.showTransactionDate,
    this.visibility,
    this.isCreatingAccount,
    this.isCreatingTransaction,
    this.isCreatingSubcategory,
    this.isSelectingSubcategory,
  });

  @override
  String toString() {
    return 'AppState: {accountId: $accountId, dateRange: $dateRange, route: $route}';
  }
}