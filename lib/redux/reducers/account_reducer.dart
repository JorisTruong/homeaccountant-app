import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final accountIdReducer = TypedReducer<int, ChangeAccount>(_accountIdReducer);
final accountInfoIdReducer = TypedReducer<int, AccountInfoId>(_accountInfoIdReducer);
final accountInfoNameReducer = TypedReducer<TextEditingController, AccountInfoName>(_accountInfoNameReducer);
final accountInfoAcronymReducer = TypedReducer<TextEditingController, AccountInfoAcronym>(_accountInfoAcronymReducer);

int _accountIdReducer(int accountId, ChangeAccount action) {
  return action.accountId;
}

int _accountInfoIdReducer(int accountInfoId, AccountInfoId action) {
  return action.accountInfoId;
}

TextEditingController _accountInfoNameReducer(TextEditingController accountInfoName, AccountInfoName action) {
  return action.accountInfoName;
}

TextEditingController _accountInfoAcronymReducer(TextEditingController accountInfoAcronym, AccountInfoAcronym action) {
  return action.accountInfoAcronym;
}