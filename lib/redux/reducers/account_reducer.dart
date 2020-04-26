import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final accountReducer = TypedReducer<String, ChangeAccount>(_accountReducer);

String _accountReducer(String account, ChangeAccount action) {
  return action.account;
}