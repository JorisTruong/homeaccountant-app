import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_pickers.dart';

import 'package:homeaccountantapp/database/models/models.dart' as models;
import 'package:homeaccountantapp/database/queries/categories.dart';
import 'package:homeaccountantapp/database/queries/exchange_rate.dart';

///
/// Queries related to the 'Transactions' entity
///

// CREATE
Future<void> createTransaction(Database db, models.Transaction transaction) async {
  await db.insert('transactions', transaction.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.ignore);
}

/// Get the transactions id of a specific subcategory id.
/// Used when deleted a subcategory.
Future<List<models.Transaction>> getTransactionFromSubcategoryId(Database db, int subcategoryId) async {
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
      'SELECT * FROM transactions WHERE subcategory_id = ?',
      [subcategoryId]
  );
  return List.generate(transactions.length, (i) {
    return models.Transaction(
      transactionId: transactions[i]['transaction_id'],
      transactionName: transactions[i]['transaction_name'],
      accountId: transactions[i]['account_id'],
      date: transactions[i]['date'],
      isExpense: transactions[i]['is_expense'] == 1 ? true : false,
      amount: transactions[i]['amount'],
      description: transactions[i]['description'],
      categoryId: transactions[i]['category_id'],
      subcategoryId: transactions[i]['subcategory_id']
    );
  });
}

/// Read all transactions of certain accounts in a given date range.
Future<List<Map<String, dynamic>>> readTransactions(Database db, Map<String, String> dateRange, List<int> accountIds) async {
  final String mainCurrency = (await db.query('main_currency'))[0]['currency'];
  final Set<dynamic> accountsCurrencies = (await db.rawQuery('SELECT account_currency FROM accounts where account_id IN (${accountIds.join(', ')})')).map((e) => e['account_currency']).toSet();
  final bool applyRates = accountIds.length > 1 && accountsCurrencies.length > 1;
  final List<List<dynamic>> accountsCurrency = await Future.wait(accountIds.map((accountId) async {
    Map<String, dynamic> a = (await db.query('accounts', where: '"account_id" = ?', whereArgs: [accountId]))[0];
    Country country = CurrencyPickerUtils.getCountryByIsoCode(a['account_country']);
    String accountCurrency = country.currencyCode;
    models.ExchangeRate exchangeRate = (await readExchangeRate(db, accountCurrency, mainCurrency));
    double rate = accountCurrency == mainCurrency ? 1 : (exchangeRate == null ? 0.0 : exchangeRate.rate);
    return [accountId, rate];
  }));
  final Map<int, double> exchangeRates = Map.fromIterable(
    accountsCurrency,
    key: (accountCurrency) => accountCurrency[0],
    value: (accountCurrency) => accountCurrency[1]
  );

  final List<Map<String, dynamic>> transactions = await db.rawQuery(
    'SELECT * FROM transactions WHERE date >= ? AND date <= ? AND account_id IN (${accountIds.map((e) => '?').join(', ')}) ORDER BY date desc',
    [dateRange['from'], dateRange['to'], ...accountIds]
  );
  return List.generate(transactions.length, (i) {
    return {
      'transactionId': transactions[i]['transaction_id'],
      'transactionName': transactions[i]['transaction_name'],
      'accountId': transactions[i]['account_id'],
      'date': transactions[i]['date'],
      'isExpense': transactions[i]['is_expense'] == 1 ? true : false,
      'amount': transactions[i]['amount'],
      'adjustedAmount': applyRates ? transactions[i]['amount'] * exchangeRates[transactions[i]['account_id']] : transactions[i]['amount'],
      'description': transactions[i]['description'],
      'categoryId': transactions[i]['category_id'],
      'subcategoryId': transactions[i]['subcategory_id']
    };
  });
}

/// Read daily transactions of a certain account, giving the expenses and income summary.
Future<List<Map<String, dynamic>>> readDailyTransactions(Database db, List<int> accountId, int offset, int limit) async {
  final String mainCurrency = (await db.query('main_currency'))[0]['currency'];
  final Set<dynamic> accountsCurrencies = (await db.rawQuery('SELECT account_currency FROM accounts where account_id IN (${accountId.join(', ')})')).map((e) => e['account_currency']).toSet();
  final bool applyRates = accountId.length > 1 && accountsCurrencies.length > 1;
  final String transactionsWithRate = 'SELECT * from transactions INNER JOIN (SELECT account_id, account_currency FROM accounts) AS a ON transactions.account_id = a.account_id LEFT JOIN (SELECT `from`, `to`, rate FROM exchange_rates WHERE `to` = "$mainCurrency") ON account_currency = `from`';
  final String adjustedTransactions = 'SELECT transaction_id, transaction_name, account_id, date, is_expense, amount * IFNULL(rate, 1.0) as amount, description, category_id, subcategory_id from ($transactionsWithRate)';
  final String dailyTransactions = 'SELECT date, is_expense, COALESCE(SUM(amount), 0.0) as total_amount, is_expense FROM (${applyRates ? adjustedTransactions : 'transactions'}) WHERE account_id IN (${accountId.map((e) => '?').join(', ')}) GROUP BY date, is_expense';
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
    'SELECT date, COALESCE(SUM(CASE WHEN is_expense=1 THEN total_amount END), 0.0) as daily_expenses, COALESCE(SUM(CASE WHEN is_expense=0 THEN total_amount END), 0.0) as daily_income FROM ($dailyTransactions) GROUP BY date ORDER BY date desc LIMIT ? offset ?',
    [...accountId, limit, offset]
  );
  return List.generate(transactions.length, (i) {
    return {
      'date': transactions[i]['date'],
      'total_income': transactions[i]['daily_income'],
      'total_expenses': transactions[i]['daily_expenses'],
      'total_balance': transactions[i]['daily_income'] + transactions[i]['daily_expenses']
    };
  });
}

/// Read monthly transactions of a certain account, giving the expenses and income summary.
Future<List<Map<String, dynamic>>> readMonthlyTransactions(Database db, List<int> accountId, int offset, int limit) async {
  final String mainCurrency = (await db.query('main_currency'))[0]['currency'];
  final Set<dynamic> accountsCurrencies = (await db.rawQuery('SELECT account_currency FROM accounts where account_id IN (${accountId.join(', ')})')).map((e) => e['account_currency']).toSet();
  final bool applyRates = accountId.length > 1 && accountsCurrencies.length > 1;
  final String transactionsWithRate = 'SELECT * from transactions INNER JOIN (SELECT account_id, account_currency FROM accounts) AS a ON transactions.account_id = a.account_id LEFT JOIN (SELECT `from`, `to`, rate FROM exchange_rates WHERE `to` = "$mainCurrency") ON account_currency = `from`';
  final String adjustedTransactions = 'SELECT transaction_id, transaction_name, account_id, date, is_expense, amount * IFNULL(rate, 1.0) as amount, description, category_id, subcategory_id from ($transactionsWithRate)';
  final String monthlyTransactions = "SELECT strftime('%m', date) as month, strftime('%Y', date) as year, is_expense, COALESCE(SUM(amount), 0.0) as total_amount, is_expense FROM (${applyRates ? adjustedTransactions : 'transactions'}) WHERE account_id IN (${accountId.map((e) => '?').join(', ')}) GROUP BY year, month, is_expense";
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
      'SELECT month, year, COALESCE(SUM(CASE WHEN is_expense=1 THEN total_amount END), 0.0) as monthly_expenses, COALESCE(SUM(CASE WHEN is_expense=0 THEN total_amount END), 0.0) as monthly_income FROM ($monthlyTransactions) GROUP BY month, year ORDER BY year desc, month desc LIMIT ? offset ?',
      [...accountId, limit, offset]
  );
  return List.generate(transactions.length, (i) {
    return {
      'date': transactions[i]['year'].toString() + '-' + transactions[i]['month'].toString(),
      'total_income': transactions[i]['monthly_income'],
      'total_expenses': transactions[i]['monthly_expenses'],
      'total_balance': transactions[i]['monthly_income'] + transactions[i]['monthly_expenses']
    };
  });
}

/// Read yearly transactions of a certain account, giving the expenses and income summary.
Future<List<Map<String, dynamic>>> readYearlyTransactions(Database db, List<int> accountId, int offset, int limit) async {
  final String mainCurrency = (await db.query('main_currency'))[0]['currency'];
  final Set<dynamic> accountsCurrencies = (await db.rawQuery('SELECT account_currency FROM accounts where account_id IN (${accountId.join(', ')})')).map((e) => e['account_currency']).toSet();
  final bool applyRates = accountId.length > 1 && accountsCurrencies.length > 1;
  final String transactionsWithRate = 'SELECT * from transactions INNER JOIN (SELECT account_id, account_currency FROM accounts) AS a ON transactions.account_id = a.account_id LEFT JOIN (SELECT `from`, `to`, rate FROM exchange_rates WHERE `to` = "$mainCurrency") ON account_currency = `from`';
  final String adjustedTransactions = 'SELECT transaction_id, transaction_name, account_id, date, is_expense, amount * IFNULL(rate, 1.0) as amount, description, category_id, subcategory_id from ($transactionsWithRate)';
  final String yearlyTransactions = "SELECT strftime('%Y', date) as year, is_expense, COALESCE(SUM(amount), 0.0) as total_amount, is_expense FROM (${applyRates ? adjustedTransactions : 'transactions'}) WHERE account_id IN (${accountId.map((e) => '?').join(', ')}) GROUP BY year, is_expense";
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
      'SELECT year, COALESCE(SUM(CASE WHEN is_expense=1 THEN total_amount END), 0.0) as yearly_expenses, COALESCE(SUM(CASE WHEN is_expense=0 THEN total_amount END), 0.0) as yearly_income FROM ($yearlyTransactions) GROUP BY year ORDER BY year desc LIMIT ? offset ?',
      [...accountId, limit, offset]
  );
  return List.generate(transactions.length, (i) {
    return {
      'date': transactions[i]['year'].toString(),
      'total_income': transactions[i]['yearly_income'],
      'total_expenses': transactions[i]['yearly_expenses'],
      'total_balance': transactions[i]['yearly_income'] + transactions[i]['yearly_expenses']
    };
  });
}

/// Get the total amount of a certain category transactions, from a given account and a given date range
Future<double> getCategoryAmount(int categoryId, Database db, Map<String, String> dateRange, List<int> accountIds, int isExpense) async {
  List<Map<String, dynamic>> categoryTransactions = (await db.rawQuery(
    'SELECT * FROM transactions WHERE category_id = ? AND date >= ? AND date <= ? AND account_id IN (${accountIds.map((e) => '?').join(', ')}) AND is_expense = ?',
    [categoryId, dateRange['from'], dateRange['to'], ...accountIds, isExpense]
  ));
  if (categoryTransactions.length == 0) {
    return 0;
  }
  final String mainCurrency = (await db.query('main_currency'))[0]['currency'];
  final Set<dynamic> accountsCurrencies = (await db.rawQuery('SELECT account_currency FROM accounts where account_id IN (${accountIds.join(', ')})')).map((e) => e['account_currency']).toSet();
  final bool applyRates = accountIds.length > 1 && accountsCurrencies.length > 1;
  final List<List<dynamic>> accountsCurrency = await Future.wait(accountIds.map((accountId) async {
    Map<String, dynamic> a = (await db.query('accounts', where: '"account_id" = ?', whereArgs: [accountId]))[0];
    Country country = CurrencyPickerUtils.getCountryByIsoCode(a['account_country']);
    String accountCurrency = country.currencyCode;
    models.ExchangeRate exchangeRate = (await readExchangeRate(db, accountCurrency, mainCurrency));
    double rate = accountCurrency == mainCurrency ? 1 : (exchangeRate == null ? 0.0 : exchangeRate.rate);
    return [accountId, rate];
  }));
  final Map<int, double> exchangeRates = Map.fromIterable(
      accountsCurrency,
      key: (accountCurrency) => accountCurrency[0],
      value: (accountCurrency) => accountCurrency[1]
  );

  double result = categoryTransactions.map((transaction) {
    return applyRates ? transaction['amount'] * exchangeRates[transaction['account_id']] : transaction['amount'];
  }).reduce((a, b) => a + b);
  return result;
}

/// Get the total amount of each categories expense transactions, from a given account and a given date range
/// Values are all positive
Future<List<Map<String, dynamic>>> getExpensesAmount(Database db, Map<String, String> dateRange, List<int> accountId) async {
  List<models.Category> categories = await readCategories(db);
  List<double> categoryExpenses = await Future.wait(List.generate(categories.length, (int i) {
    return getCategoryAmount(categories[i].categoryId, db, dateRange, accountId, 1);
  }));
  return List.generate(categoryExpenses.length, (int i) {
    return {'name': categories[i].categoryName, 'expenses': categoryExpenses[i] == 0 ? -0.0 : -categoryExpenses[i]};
  });
}

/// Get the total amount of all expense transactions, from a given account and a given date range
Future<double> getTotalExpense(Database db, Map<String, String> dateRange, List<int> accountIds) async {
  List<Map<String, dynamic>> expenseTransactions = dateRange != null ? (await db.rawQuery(
    'SELECT * FROM transactions WHERE date >= ? AND date <= ? AND account_id IN (${accountIds.map((e) => '?').join(', ')}) AND is_expense = 1',
    [dateRange['from'], dateRange['to'], ...accountIds]
  )) :
  (await db.rawQuery(
    'SELECT * FROM transactions WHERE account_id IN (${accountIds.map((e) => '?').join(', ')}) AND is_expense = 1',
    [...accountIds]
  ));
  if (expenseTransactions.length == 0) {
    return 0;
  }

  final String mainCurrency = (await db.query('main_currency'))[0]['currency'];
  final Set<dynamic> accountsCurrencies = (await db.rawQuery('SELECT account_currency FROM accounts where account_id IN (${accountIds.join(', ')})')).map((e) => e['account_currency']).toSet();
  final bool applyRates = accountIds.length > 1 && accountsCurrencies.length > 1;
  final List<List<dynamic>> accountsCurrency = await Future.wait(accountIds.map((accountId) async {
    Map<String, dynamic> a = (await db.query('accounts', where: '"account_id" = ?', whereArgs: [accountId]))[0];
    Country country = CurrencyPickerUtils.getCountryByIsoCode(a['account_country']);
    String accountCurrency = country.currencyCode;
    models.ExchangeRate exchangeRate = (await readExchangeRate(db, accountCurrency, mainCurrency));
    double rate = accountCurrency == mainCurrency ? 1 : (exchangeRate == null ? 0.0 : exchangeRate.rate);
    return [accountId, rate];
  }));
  final Map<int, double> exchangeRates = Map.fromIterable(
      accountsCurrency,
      key: (accountCurrency) => accountCurrency[0],
      value: (accountCurrency) => accountCurrency[1]
  );

  double totalExpense = expenseTransactions.map((transaction) {
    return applyRates ? transaction['amount'] * exchangeRates[transaction['account_id']] : transaction['amount'];
  }).reduce((a, b) => a + b);
  return -totalExpense;
}

/// Get the proportion of each categories expense transactions, from a given account and a given date range
Future<List<Map<String, dynamic>>> getExpensesProportion(Database db, Map<String, String> dateRange, List<int> accountId) async {
  double totalExpenses = await getTotalExpense(db, dateRange, accountId);
  if (totalExpenses == null || totalExpenses == 0) {
    List<models.Category> categories = await readCategories(db);
    return List.generate(categories.length, (int i) {
      return {'name': categories[i].categoryName, 'value': 0, 'percentage': 0};
    });
  } else {
    var result = await getExpensesAmount(db, dateRange, accountId);
    return List.generate(result.length, (int i) {
      return {
        'name': result[i]['name'],
        'value': -result[i]['expenses'],
        'percentage': 100 * result[i]['expenses'] / totalExpenses
      };
    });
  }
}

/// Get the total amount of each categories income transactions, from a given account and a given date range
/// Values are all positive
Future<List<Map<String, dynamic>>> getIncomeAmount(Database db, Map<String, String> dateRange, List<int> accountId) async {
  List<models.Category> categories = await readCategories(db);
  List<double> categoryIncome = await Future.wait(List.generate(categories.length, (int i) {
    return getCategoryAmount(categories[i].categoryId, db, dateRange, accountId, 0);
  }));
  return List.generate(categoryIncome.length, (int i) {
    return {'name': categories[i].categoryName, 'income': categoryIncome[i]};
  });
}

/// /// Get the total amount of all income transactions, from a given account and a given date range
Future<double> getTotalIncome(Database db, Map<String, String> dateRange, List<int> accountIds) async {
  List<Map<String, dynamic>> incomeTransactions = dateRange != null ? (await db.rawQuery(
    'SELECT * FROM transactions WHERE date >= ? AND date <= ? AND account_id IN (${accountIds.map((e) => '?').join(', ')}) AND is_expense = 0',
    [dateRange['from'], dateRange['to'], ...accountIds]
  )) :
  (await db.rawQuery(
    'SELECT * FROM transactions WHERE account_id IN (${accountIds.map((e) => '?').join(', ')}) AND is_expense = 0',
    [...accountIds]
  ));
  if (incomeTransactions.length == 0) {
    return 0;
  }

  final String mainCurrency = (await db.query('main_currency'))[0]['currency'];
  final Set<dynamic> accountsCurrencies = (await db.rawQuery('SELECT account_currency FROM accounts where account_id IN (${accountIds.join(', ')})')).map((e) => e['account_currency']).toSet();
  final bool applyRates = accountIds.length > 1 && accountsCurrencies.length > 1;
  final List<List<dynamic>> accountsCurrency = await Future.wait(accountIds.map((accountId) async {
    Map<String, dynamic> a = (await db.query('accounts', where: '"account_id" = ?', whereArgs: [accountId]))[0];
    Country country = CurrencyPickerUtils.getCountryByIsoCode(a['account_country']);
    String accountCurrency = country.currencyCode;
    models.ExchangeRate exchangeRate = (await readExchangeRate(db, accountCurrency, mainCurrency));
    double rate = accountCurrency == mainCurrency ? 1 : (exchangeRate == null ? 0.0 : exchangeRate.rate);
    return [accountId, rate];
  }));
  final Map<int, double> exchangeRates = Map.fromIterable(
      accountsCurrency,
      key: (accountCurrency) => accountCurrency[0],
      value: (accountCurrency) => accountCurrency[1]
  );

  double totalIncome = incomeTransactions.map((transaction) {
    return applyRates ? transaction['amount'] * exchangeRates[transaction['account_id']] : transaction['amount'];
  }).reduce((a, b) => a + b);
  return totalIncome;
}

/// Get the proportion of each categories income transactions, from a given account and a given date range
Future<List<Map<String, dynamic>>> getIncomeProportion(Database db, Map<String, String> dateRange, List<int> accountId) async {
  double totalIncome = await getTotalIncome(db, dateRange, accountId);
  if (totalIncome == null || totalIncome == 0) {
    List<models.Category> categories = await readCategories(db);
    return List.generate(categories.length, (int i) {
      return {'name': categories[i].categoryName, 'value': 0, 'percentage': 0};
    });
  } else {
    var result = await getIncomeAmount(db, dateRange, accountId);
    return List.generate(result.length, (int i) {
      return {
        'name': result[i]['name'],
        'value': result[i]['income'],
        'percentage': 100 * result[i]['income'] / totalIncome
      };
    });
  }
}

/// Get the total balance of a certain account in a given date range.
/// Used in a main card in homepage.
Future<double> getTotalBalance(Database db, Map<String, String> dateRange, List<int> accountId) async {
  double totalExpenses = await getTotalExpense(db, dateRange, accountId);
  double totalIncome = await getTotalIncome(db, dateRange, accountId);
  return totalIncome - totalExpenses;
}

// UPDATE
Future<void> updateTransaction(Database db, models.Transaction updatedTransaction) async {
  await db.update(
    'transactions',
    updatedTransaction.toMap(),
    where: 'transaction_id = ?',
    whereArgs: [updatedTransaction.transactionId],
  );
}

// DELETE
Future<void> deleteTransaction(Database db, int transactionId) async {
  await db.delete(
      'transactions',
      where: 'transaction_id = ?',
      whereArgs: [transactionId]
  );
}