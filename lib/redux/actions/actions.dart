import 'package:flutter/material.dart';

class ChangeAccount {
  final int accountId;

  ChangeAccount(this.accountId);
}

class UpdateDateRange {
  final String dateRange;

  UpdateDateRange(this.dateRange);
}

class TransactionName {
  final TextEditingController name;

  TransactionName(this.name);
}

class TransactionAccount {
  final int accountId;

  TransactionAccount(this.accountId);
}

class TransactionDate {
  final TextEditingController date;

  TransactionDate(this.date);
}

class TransactionIsExpense {
  final bool isExpense;

  TransactionIsExpense(this.isExpense);
}

class SelectCategory {
  final int categoryIndex;

  SelectCategory(this.categoryIndex);
}

class SelectSubcategory {
  final Map<String, dynamic> subcategory;

  SelectSubcategory(this.subcategory);
}

class SubcategoryText {
  final TextEditingController subcategory;

  SubcategoryText(this.subcategory);
}

class SelectSubcategoryIcon {
  final Icon subcategoryIcon;

  SelectSubcategoryIcon(this.subcategoryIcon);
}

class TransactionAmount {
  final TextEditingController amount;

  TransactionAmount(this.amount);
}

class TransactionDescription {
  final TextEditingController description;

  TransactionDescription(this.description);
}

class NavigateReplaceAction {
  final String routeName;

  NavigateReplaceAction(this.routeName);
}

class NavigatePushAction {
  final String routeName;

  NavigatePushAction(this.routeName);
}

class NavigatePopAction {

}