import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart' as models;
import 'package:homeaccountantapp/database/queries/categories.dart';

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

/// Read all transactions of a certain account in a given date range.
Future<List<models.Transaction>> readTransactions(Database db, Map<String, String> dateRange, int accountId) async {
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
    'SELECT * FROM transactions WHERE date >= ? AND date <= ? AND account_id = ? ORDER BY date desc',
    [dateRange['from'], dateRange['to'], accountId]
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

/// Read daily transactions of a certain account, giving the expenses and income summary.
Future<List<Map<String, dynamic>>> readDailyTransactions(Database db, int accountId, int offset, int limit) async {
  final String dailyTransactions = 'SELECT date, is_expense, COALESCE(SUM(amount), 0.0) as total_amount, is_expense FROM transactions WHERE account_id = ? GROUP BY date, is_expense';
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
    'SELECT date, COALESCE(SUM(CASE WHEN is_expense=1 THEN total_amount END), 0.0) as daily_expenses, COALESCE(SUM(CASE WHEN is_expense=0 THEN total_amount END), 0.0) as daily_income FROM ('
        + dailyTransactions + ') GROUP BY date ORDER BY date desc LIMIT ? offset ?',
    [accountId, limit, offset]
  );
  return List.generate(transactions.length, (i) {
    return {
      'date': transactions[i]['date'],
      'total_income': transactions[i]['daily_income'],
      'total_expenses': transactions[i]['daily_expenses']
    };
  });
}

/// Read monthly transactions of a certain account, giving the expenses and income summary.
Future<List<Map<String, dynamic>>> readMonthlyTransactions(Database db, int accountId, int offset, int limit) async {
  final String dailyTransactions = "SELECT strftime('%m', date) as month, strftime('%Y', date) as year, is_expense, COALESCE(SUM(amount), 0.0) as total_amount, is_expense FROM transactions WHERE account_id = ? GROUP BY year, month, is_expense";
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
      'SELECT month, year, COALESCE(SUM(CASE WHEN is_expense=1 THEN total_amount END), 0.0) as monthly_expenses, COALESCE(SUM(CASE WHEN is_expense=0 THEN total_amount END), 0.0) as monthly_income FROM ('
          + dailyTransactions + ') GROUP BY month, year ORDER BY year desc, month desc LIMIT ? offset ?',
      [accountId, limit, offset]
  );
  return List.generate(transactions.length, (i) {
    return {
      'date': transactions[i]['year'].toString() + '-' + transactions[i]['month'].toString(),
      'total_income': transactions[i]['monthly_income'],
      'total_expenses': transactions[i]['monthly_expenses']
    };
  });
}

/// Read yearly transactions of a certain account, giving the expenses and income summary.
Future<List<Map<String, dynamic>>> readYearlyTransactions(Database db, int accountId, int offset, int limit) async {
  final String dailyTransactions = "SELECT strftime('%Y', date) as year, is_expense, COALESCE(SUM(amount), 0.0) as total_amount, is_expense FROM transactions WHERE account_id = ? GROUP BY year, is_expense";
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
      'SELECT year, COALESCE(SUM(CASE WHEN is_expense=1 THEN total_amount END), 0.0) as yearly_expenses, COALESCE(SUM(CASE WHEN is_expense=0 THEN total_amount END), 0.0) as yearly_income FROM ('
          + dailyTransactions + ') GROUP BY year ORDER BY year desc LIMIT ? offset ?',
      [accountId, limit, offset]
  );
  return List.generate(transactions.length, (i) {
    return {
      'date': transactions[i]['year'].toString(),
      'total_income': transactions[i]['yearly_income'],
      'total_expenses': transactions[i]['yearly_expenses']
    };
  });
}

/// Get the total amount of a certain category transactions, from a given account and a given date range
Future<double> getCategoryAmount(int categoryId, Database db, Map<String, String> dateRange, int accountId, int isExpense) async {
  double result = (await db.rawQuery(
    'SELECT SUM(amount) as total FROM transactions WHERE category_id = ? AND date >= ? AND date <= ? AND account_id = ? AND is_expense = ?',
    [categoryId, dateRange['from'], dateRange['to'], accountId, isExpense]
  ))[0]['total'];
  if (result == null) {
    return 0;
  }
  return result;
}

/// Get the total amount of each categories expense transactions, from a given account and a given date range
/// Values are all positive
Future<List<Map<String, dynamic>>> getExpensesAmount(Database db, Map<String, String> dateRange, int accountId) async {
  List<models.Category> categories = await readCategories(db);
  List<double> categoryExpenses = await Future.wait(List.generate(categories.length, (int i) {
    return getCategoryAmount(categories[i].categoryId, db, dateRange, accountId, 1);
  }));
  return List.generate(categoryExpenses.length, (int i) {
    return {'name': categories[i].categoryName, 'expenses': categoryExpenses[i] == 0 ? -0.0 : -categoryExpenses[i]};
  });
}

/// Get the total amount of all expense transactions, from a given account and a given date range
Future<double> getTotalExpense(Database db, Map<String, String> dateRange, int accountId) async {
  double totalExpense = dateRange != null ? (await db.rawQuery(
    'SELECT SUM(amount) as total FROM transactions WHERE date >= ? AND date <= ? AND account_id = ? AND is_expense = 1',
    [dateRange['from'], dateRange['to'], accountId]
  ))[0]['total'] :
  (await db.rawQuery(
    'SELECT SUM(amount) as total FROM transactions WHERE account_id = ? AND is_expense = 1',
    [accountId]
  ))[0]['total'];
  if (totalExpense == null) {
    return 0;
  }
  return -totalExpense;
}

/// Get the proportion of each categories expense transactions, from a given account and a given date range
Future<List<Map<String, dynamic>>> getExpensesProportion(Database db, Map<String, String> dateRange, int accountId) async {
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
Future<List<Map<String, dynamic>>> getIncomeAmount(Database db, Map<String, String> dateRange, int accountId) async {
  List<models.Category> categories = await readCategories(db);
  List<double> categoryIncome = await Future.wait(List.generate(categories.length, (int i) {
    return getCategoryAmount(categories[i].categoryId, db, dateRange, accountId, 0);
  }));
  return List.generate(categoryIncome.length, (int i) {
    return {'name': categories[i].categoryName, 'income': categoryIncome[i]};
  });
}

/// /// Get the total amount of all income transactions, from a given account and a given date range
Future<double> getTotalIncome(Database db, Map<String, String> dateRange, int accountId) async {
  double totalIncome = dateRange != null ? (await db.rawQuery(
    'SELECT SUM(amount) as total FROM transactions WHERE date >= ? AND date <= ? AND account_id = ? AND is_expense = 0',
    [dateRange['from'], dateRange['to'], accountId]
  ))[0]['total'] :
  (await db.rawQuery(
    'SELECT SUM(amount) as total FROM transactions WHERE account_id = ? AND is_expense = 0',
    [accountId]
  ))[0]['total'];
  if (totalIncome == null) {
    return 0;
  }
  return totalIncome;
}

/// Get the proportion of each categories income transactions, from a given account and a given date range
Future<List<Map<String, dynamic>>> getIncomeProportion(Database db, Map<String, String> dateRange, int accountId) async {
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
Future<double> getTotalBalance(Database db, Map<String, String> dateRange, int accountId) async {
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