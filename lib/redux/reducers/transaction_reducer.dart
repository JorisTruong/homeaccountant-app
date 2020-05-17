import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final transactionNameReducer = TypedReducer<TextEditingController, TransactionName>(_transactionName);
final transactionAccountReducer = TypedReducer<String, TransactionAccount>(_transactionAccount);
final transactionDateReducer = TypedReducer<TextEditingController, TransactionDate>(_transactionDate);
final transactionIsExpenseReducer = TypedReducer<bool, TransactionIsExpense>(_transactionIsExpense);
final transactionAmountReducer = TypedReducer<TextEditingController, TransactionAmount>(_transactionAmount);
final transactionDescriptionReducer = TypedReducer<TextEditingController, TransactionDescription>(_transactionDescription);

TextEditingController _transactionName(TextEditingController name, TransactionName action) {
  return action.name;
}

String _transactionAccount(String account, TransactionAccount action) {
  return action.account;
}

TextEditingController _transactionDate(TextEditingController date, TransactionDate action) {
  return action.date;
}

bool _transactionIsExpense(bool isExpense, TransactionIsExpense action) {
  return action.isExpense;
}

TextEditingController _transactionAmount(TextEditingController amount, TransactionAmount action) {
  return action.amount;
}

TextEditingController _transactionDescription(TextEditingController description, TransactionDescription action) {
  return action.description;
}