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
  final List<Map<String, dynamic>> transactions = await db.rawQuery('SELECT * FROM transactions WHERE date >= ? AND date <= ? AND account_id = ?',
      [dateRange['from'], dateRange['to'], accountId]);
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