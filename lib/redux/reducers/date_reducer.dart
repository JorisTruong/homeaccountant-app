import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final dateReducer = TypedReducer<Map<String, String>, UpdateDateRange>(_dateReducer);

Map<String, String> _dateReducer(Map<String, String> dateRange, UpdateDateRange action) {
  return action.dateRange;
}