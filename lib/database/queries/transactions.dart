import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:homeaccountantapp/utils.dart';
import 'package:homeaccountantapp/database/models/models.dart' as models;

///
/// Queries related to the 'Transactions' entity
///

// CREATE
Future<void> createTransaction(Database db, models.Transaction transaction) async {
  await db.insert('transactions', transaction.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.ignore);
}

// READ
Future<List<models.Transaction>> readTransactions(Database db, Map<String, String> dateRange, int accountId) async {
  final List<Map<String, dynamic>> transactions = await db.rawQuery(
    'SELECT * FROM transactions WHERE date >= ? AND date <= ? AND account_id = ?',
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

Future<Map<String, List<models.Transaction>>> getTransactions(Database db, String dateRangeType, Map<String, String> dateRange, int accountId) async {
  // Get year
  String year = dateRange['from'].split('-')[0];
  if (dateRangeType == 'Year') {
    return {
      'January ' + year: await readTransactions(db, {'from': year + '-01-01', 'to': year + '-01-31'}, accountId),
      'February ' + year: await readTransactions(db, {'from': year + '-02-01', 'to': year + '-02-29'}, accountId),
      'March ' + year: await readTransactions(db, {'from': year + '-03-01', 'to': year + '-03-31'}, accountId),
      'April ' + year: await readTransactions(db, {'from': year + '-04-01', 'to': year + '-04-30'}, accountId),
      'May ' + year: await readTransactions(db, {'from': year + '-05-01', 'to': year + '-05-31'}, accountId),
      'June ' + year: await readTransactions(db, {'from': year + '-06-01', 'to': year + '-06-30'}, accountId),
      'July ' + year: await readTransactions(db, {'from': year + '-07-01', 'to': year + '-07-31'}, accountId),
      'August ' + year: await readTransactions(db, {'from': year + '-08-01', 'to': year + '-08-31'}, accountId),
      'September ' + year: await readTransactions(db, {'from': year + '-09-01', 'to': year + '-09-30'}, accountId),
      'October ' + year: await readTransactions(db, {'from': year + '-10-01', 'to': year + '-10-31'}, accountId),
      'November ' + year: await readTransactions(db, {'from': year + '-11-01', 'to': year + '-11-30'}, accountId),
      'December ' + year: await readTransactions(db, {'from': year + '-12-01', 'to': year + '-12-31'}, accountId)
    };
  } else {
    // Get month
    String month = dateRange['from'].split('-')[1];
    return {
      getMonth(month) + year: await readTransactions(db, dateRange, accountId)
    };
  }
}

Future<double> getCategoryAmount(int categoryId, Database db, String dateRangeType, Map<String, String> dateRange, int accountId, int isExpense) async {
  double result = (await db.rawQuery(
    'SELECT SUM(amount) as total FROM transactions WHERE category_id = ? AND date >= ? AND date <= ? AND account_id = ? AND is_expense = ?',
    [categoryId, dateRange['from'], dateRange['to'], accountId, isExpense]
  ))[0]['total'];
  if (result == null) {
    return 0;
  } else {
    return result;
  }
}

Future<List<Map<String, dynamic>>> getExpensesAmount(Database db, String dateRangeType, Map<String, String> dateRange, int accountId) async {
  double category1Expenses = await getCategoryAmount(0, db, dateRangeType, dateRange, accountId, 1);
  double category2Expenses = await getCategoryAmount(1, db, dateRangeType, dateRange, accountId, 1);
  double category3Expenses = await getCategoryAmount(2, db, dateRangeType, dateRange, accountId, 1);
  double category4Expenses = await getCategoryAmount(3, db, dateRangeType, dateRange, accountId, 1);
  double category5Expenses = await getCategoryAmount(4, db, dateRangeType, dateRange, accountId, 1);
  return [
    {'name': 'Category 1', 'expenses': category1Expenses},
    {'name': 'Category 2', 'expenses': category2Expenses},
    {'name': 'Category 3', 'expenses': category3Expenses},
    {'name': 'Category 4', 'expenses': category4Expenses},
    {'name': 'Category 5', 'expenses': category5Expenses}
  ];
}

Future<List<Map<String, dynamic>>> getExpensesProportion(Database db, String dateRangeType, Map<String, String> dateRange, int accountId) async {
  double totalExpenses = (await db.rawQuery(
    'SELECT SUM(amount) as total FROM transactions WHERE date >= ? AND date <= ? AND account_id = ? AND is_expense = 1',
    [dateRange['from'], dateRange['to'], accountId]
  ))[0]['total'];
  if (totalExpenses == null || totalExpenses == 0) {
    return [
      {'name': 'Category 1', 'percentage': 0},
      {'name': 'Category 2', 'percentage': 0},
      {'name': 'Category 3', 'percentage': 0},
      {'name': 'Category 4', 'percentage': 0},
      {'name': 'Category 5', 'percentage': 0}
    ];
  } else {
    var result = await getExpensesAmount(db, dateRangeType, dateRange, accountId);
    return List.generate(result.length, (int i) {
      return {
        'name': result[i]['name'],
        'percentage': 100 * result[i]['expenses'] / totalExpenses
      };
    });
  }
}

Future<List<Map<String, dynamic>>> getIncomeAmount(Database db, String dateRangeType, Map<String, String> dateRange, int accountId) async {
  double category1Income = await getCategoryAmount(0, db, dateRangeType, dateRange, accountId, 0);
  double category2Income = await getCategoryAmount(1, db, dateRangeType, dateRange, accountId, 0);
  double category3Income = await getCategoryAmount(2, db, dateRangeType, dateRange, accountId, 0);
  double category4Income = await getCategoryAmount(3, db, dateRangeType, dateRange, accountId, 0);
  double category5Income = await getCategoryAmount(4, db, dateRangeType, dateRange, accountId, 0);
  return [
    {'name': 'Category 1', 'income': category1Income},
    {'name': 'Category 2', 'income': category2Income},
    {'name': 'Category 3', 'income': category3Income},
    {'name': 'Category 4', 'income': category4Income},
    {'name': 'Category 5', 'income': category5Income}
  ];
}

Future<List<Map<String, dynamic>>> getIncomeProportion(Database db, String dateRangeType, Map<String, String> dateRange, int accountId) async {
  double totalIncome = (await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE date >= ? AND date <= ? AND account_id = ? AND is_expense = 0',
      [dateRange['from'], dateRange['to'], accountId]
  ))[0]['total'];
  if (totalIncome == null || totalIncome == 0) {
    return [
      {'name': 'Category 1', 'percentage': 0},
      {'name': 'Category 2', 'percentage': 0},
      {'name': 'Category 3', 'percentage': 0},
      {'name': 'Category 4', 'percentage': 0},
      {'name': 'Category 5', 'percentage': 0}
    ];
  } else {
    var result = await getIncomeAmount(db, dateRangeType, dateRange, accountId);
    return List.generate(result.length, (int i) {
      return {
        'name': result[i]['name'],
        'percentage': 100 * result[i]['income'] / totalIncome
      };
    });
  }
}

Future<List<Map<String, dynamic>>> getTransactionsAmount(Database db, String dateRangeType, Map<String, String> dateRange, int accountId) async {
  var expensesAmount = await getExpensesAmount(db, dateRangeType, dateRange, accountId);
  var incomeAmount = await getIncomeAmount(db, dateRangeType, dateRange, accountId);
  return List.generate(expensesAmount.length, (int i) {
    return {
      'name': expensesAmount[i]['name'], 'expenses': expensesAmount[i]['expenses'], 'income': incomeAmount[i]['income']
    };
  });
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