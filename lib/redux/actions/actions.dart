import 'package:flutter/material.dart';

class ChangeAccount {
  final int accountId;

  ChangeAccount(this.accountId);
}

class AccountInfoId {
  final int accountInfoId;

  AccountInfoId(this.accountInfoId);
}

class AccountInfoName {
  final TextEditingController accountInfoName;

  AccountInfoName(this.accountInfoName);
}

class AccountInfoAcronym {
  final TextEditingController accountInfoAcronym;

  AccountInfoAcronym(this.accountInfoAcronym);
}

class AccountInfoCountryIso {
  final String accountInfoCountryIso;

  AccountInfoCountryIso(this.accountInfoCountryIso);
}

class AccountInfoCurrencyText {
  final TextEditingController accountInfoCurrencyText;

  AccountInfoCurrencyText(this.accountInfoCurrencyText);
}

class MainCountryIso {
  final String mainCountryIso;

  MainCountryIso(this.mainCountryIso);
}

class MainCurrencyText {
  final TextEditingController mainCurrencyText;

  MainCurrencyText(this.mainCurrencyText);
}

class UpdateDateRangeType {
  final String dateRangeType;

  UpdateDateRangeType(this.dateRangeType);
}

class UpdateSelectedDate {
  final DateTime selectedDate;

  UpdateSelectedDate(this.selectedDate);
}

class UpdateDateRange {
  final Map<String, String> dateRange;

  UpdateDateRange(this.dateRange);
}

class TransactionId {
  final int transactionId;

  TransactionId(this.transactionId);
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

class TransactionSubcategoryId {
  final int subcategoryId;

  TransactionSubcategoryId(this.subcategoryId);
}

class TransactionSubcategoryText {
  final TextEditingController subcategory;

  TransactionSubcategoryText(this.subcategory);
}

class TransactionSelectSubcategoryIcon {
  final Icon subcategoryIcon;

  TransactionSelectSubcategoryIcon(this.subcategoryIcon);
}

class CategorySubcategoryId {
  final int subcategoryId;

  CategorySubcategoryId(this.subcategoryId);
}

class CategorySubcategoryText {
  final TextEditingController subcategory;

  CategorySubcategoryText(this.subcategory);
}

class CategorySelectSubcategoryIcon {
  final Icon subcategoryIcon;

  CategorySelectSubcategoryIcon(this.subcategoryIcon);
}

class TransactionAmount {
  final TextEditingController amount;

  TransactionAmount(this.amount);
}

class TransactionDescription {
  final TextEditingController description;

  TransactionDescription(this.description);
}

class ShowTransactionType {
  final String showTransactionType;

  ShowTransactionType(this.showTransactionType);
}

class ShowTransactionDate {
  final TextEditingController showTransactionDate;

  ShowTransactionDate(this.showTransactionDate);
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

class IsCreatingAccount {
  final bool isCreatingAccount;

  IsCreatingAccount(this.isCreatingAccount);
}

class IsCreatingTransaction {
  final bool isCreatingTransaction;

  IsCreatingTransaction(this.isCreatingTransaction);
}

class IsCreatingSubcategory {
  final bool isCreatingSubcategory;

  IsCreatingSubcategory(this.isCreatingSubcategory);
}

class IsSelectingSubcategory {
  final bool isSelectingSubcategory;

  IsSelectingSubcategory(this.isSelectingSubcategory);
}