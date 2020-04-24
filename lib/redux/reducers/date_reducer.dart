import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final dateReducer = TypedReducer<String, UpdateDateRange>(_dateReducer);

String _dateReducer(String dateRange, UpdateDateRange action) {
  return action.dateRange;
}