import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/redux/reducers/date_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    dateRange: dateReducer(state.dateRange, action)
  );
}