import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final accountIdReducer = TypedReducer<int, ChangeAccount>(_accountIdReducer);

int _accountIdReducer(int accountId, ChangeAccount action) {
  return action.accountId;
}