import 'package:homeaccountantapp/redux/models/models.dart';
import 'package:homeaccountantapp/redux/reducers/account_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/category_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/date_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/navigation_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/transaction_reducer.dart';
import 'package:homeaccountantapp/redux/reducers/utils_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    accountId: accountIdReducer(state.accountId, action),
    accountInfoId: accountInfoIdReducer(state.accountInfoId, action),
    accountInfoName: accountInfoNameReducer(state.accountInfoName, action),
    accountInfoAcronym: accountInfoAcronymReducer(state.accountInfoAcronym, action),
    accountInfoCountryIso: accountInfoCurrencyReducer(state.accountInfoCountryIso, action),
    accountInfoCurrencyText: accountInfoCurrencyTextReducer(state.accountInfoCurrencyText, action),
    mainCountryIso: mainCountryIsoReducer(state.mainCountryIso, action),
    mainCurrencyText: mainCurrencyTextReducer(state.mainCurrencyText, action),
    transactionId: transactionIdReducer(state.transactionId, action),
    transactionName: transactionNameReducer(state.transactionName, action),
    transactionAccountId: transactionAccountIdReducer(state.transactionAccountId, action),
    transactionDate: transactionDateReducer(state.transactionDate, action),
    transactionIsExpense: transactionIsExpenseReducer(state.transactionIsExpense, action),
    categoryIndex: categoryReducer(state.categoryIndex, action),
    categorySubcategoryId: categorySubcategoryIdReducer(state.categorySubcategoryId, action),
    categorySubcategoryText: categorySubcategoryTextReducer(state.categorySubcategoryText, action),
    categorySubcategoryIcon: categorySubcategoryIconReducer(state.categorySubcategoryIcon, action),
    transactionSubcategoryId: transactionSubcategoryIdReducer(state.transactionSubcategoryId, action),
    transactionSubcategoryText: transactionSubcategoryTextReducer(state.transactionSubcategoryText, action),
    transactionSubcategoryIcon: transactionSubcategoryIconReducer(state.transactionSubcategoryIcon, action),
    transactionAmount: transactionAmountReducer(state.transactionAmount, action),
    transactionDescription: transactionDescriptionReducer(state.transactionDescription, action),
    dateRangeType: dateRangeReducer(state.dateRangeType, action),
    selectedDate: selectedDateReducer(state.selectedDate, action),
    dateRange: dateReducer(state.dateRange, action),
    route: navigationReducer(state.route, action),
    balance: changeBalanceReducer(state.balance, action),
    showTransactionType: showTransactionTypeReducer(state.showTransactionType, action),
    showTransactionDate: showTransactionDateReducer(state.showTransactionDate, action),
    isCreatingAccount: isCreatingAccountReducer(state.isCreatingAccount, action),
    isCreatingTransaction: isCreatingTransactionReducer(state.isCreatingTransaction, action),
    isCreatingSubcategory: isCreatingSubcategoryReducer(state.isCreatingSubcategory, action),
    isSelectingSubcategory: isSelectingSubcategoryReducer(state.isSelectingSubcategory, action)
  );
}