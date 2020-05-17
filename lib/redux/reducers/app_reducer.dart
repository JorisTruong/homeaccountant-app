import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/redux/reducers/account_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/category_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/date_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/navigation_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/transaction_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    account: accountReducer(state.account, action),
    transactionName: transactionNameReducer(state.transactionName, action),
    transactionAccount: transactionAccountReducer(state.transactionAccount, action),
    transactionDate: transactionDateReducer(state.transactionDate, action),
    transactionIsExpense: transactionIsExpenseReducer(state.transactionIsExpense, action),
    categoryIndex: categoryReducer(state.categoryIndex, action),
    subcategory: subcategoryReducer(state.subcategory, action),
    subcategoryText: subcategoryTextReducer(state.subcategoryText, action),
    subcategoryIcon: subcategoryIconReducer(state.subcategoryIcon, action),
    transactionAmount: transactionAmountReducer(state.transactionAmount, action),
    transactionDescription: transactionDescriptionReducer(state.transactionDescription, action),
    dateRange: dateReducer(state.dateRange, action),
    route: navigationReducer(state.route, action)
  );
}