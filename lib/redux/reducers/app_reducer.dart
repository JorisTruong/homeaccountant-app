import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/redux/reducers/account_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/date_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/navigation_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    account: accountReducer(state.account, action),
    dateRange: dateReducer(state.dateRange, action),
    route: navigationReducer(state.route, action)
  );
}