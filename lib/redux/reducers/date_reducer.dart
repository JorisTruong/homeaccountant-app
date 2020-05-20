import 'package:redux/redux.dart';

import 'package:homeaccountantapp/redux/actions/actions.dart';

final dateReducer = TypedReducer<Map<String, String>, UpdateDateRange>(_dateReducer);
final dateRangeReducer = TypedReducer<String, UpdateDateRangeType>(_dateRangeTypeReducer);
final selectedDateReducer = TypedReducer<DateTime, UpdateSelectedDate>(_selectedDateTypeReducer);

Map<String, String> _dateReducer(Map<String, String> dateRange, UpdateDateRange action) {
  return action.dateRange;
}

String _dateRangeTypeReducer(String dateRangeType, UpdateDateRangeType action) {
  return action.dateRangeType;
}

DateTime _selectedDateTypeReducer(DateTime selectedDate, UpdateSelectedDate action) {
  return action.selectedDate;
}