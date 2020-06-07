import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final transactionNameReducer = TypedReducer<TextEditingController, TransactionName>(_transactionName);
final transactionAccountIdReducer = TypedReducer<int, TransactionAccount>(_transactionAccountId);
final transactionDateReducer = TypedReducer<TextEditingController, TransactionDate>(_transactionDate);
final transactionSubcategoryIdReducer = TypedReducer<int, TransactionSubcategoryId>(_subcategoryId);
final transactionSubcategoryTextReducer = TypedReducer<TextEditingController, TransactionSubcategoryText>(_subcategoryText);
final transactionSubcategoryIconReducer = TypedReducer<Icon, TransactionSelectSubcategoryIcon>(_subcategoryIcon);
final transactionIsExpenseReducer = TypedReducer<bool, TransactionIsExpense>(_transactionIsExpense);
final transactionAmountReducer = TypedReducer<TextEditingController, TransactionAmount>(_transactionAmount);
final transactionDescriptionReducer = TypedReducer<TextEditingController, TransactionDescription>(_transactionDescription);

TextEditingController _transactionName(TextEditingController name, TransactionName action) {
  return action.name;
}

int _transactionAccountId(int accountId, TransactionAccount action) {
  return action.accountId;
}

TextEditingController _transactionDate(TextEditingController date, TransactionDate action) {
  return action.date;
}

bool _transactionIsExpense(bool isExpense, TransactionIsExpense action) {
  return action.isExpense;
}

int _subcategoryId(int subcategoryId, TransactionSubcategoryId action) {
  return action.subcategoryId;
}

TextEditingController _subcategoryText(TextEditingController subcategory, TransactionSubcategoryText action) {
  return action.subcategory;
}

Icon _subcategoryIcon(Icon subcategoryIcon, TransactionSelectSubcategoryIcon action) {
  return action.subcategoryIcon;
}

TextEditingController _transactionAmount(TextEditingController amount, TransactionAmount action) {
  return action.amount;
}

TextEditingController _transactionDescription(TextEditingController description, TransactionDescription action) {
  return action.description;
}