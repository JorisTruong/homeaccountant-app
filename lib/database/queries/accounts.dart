import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart';

///
/// Queries related to the 'Accounts' entity
///

// CREATE
Future<void> createAccount(Future<Database> database, Account account) async {
  final Database db = await database;
  await db.insert('accounts', account.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
}

// READ ALL
Future<List<Account>> readAccounts(Future<Database> database) async {
  final Database db = await database;
  final List<Map<String, dynamic>> accounts = await db.query('accounts');
  return List.generate(accounts.length, (i) {
    return Account(
        accountId: accounts[i]['account_id'],
        accountName: accounts[i]['account_name'],
        accountAcronym: accounts[i]['account_acronym']
    );
  });
}

// READ ONE
Future<Account> accountFromId(Future<Database> database, int accountId) async {
  final Database db = await database;
  final Map<String, dynamic> account = (await db.rawQuery('SELECT * FROM accounts WHERE account_id=?', [accountId]))[0];
  return Account(
    accountId: account['account_id'],
    accountName: account['account_name'],
    accountAcronym: account['account_acronym']
  );
}

// UPDATE
Future<void> updateAccount(Future<Database> database, Account updatedAccount) async {
  final Database db = await database;
  await db.update(
    'accounts',
    updatedAccount.toMap(),
    where: 'account_id = ?',
    whereArgs: [updatedAccount.accountId]
  );
}

// DELETE
Future<void> deleteAccount(Future<Database> database, int accountId) async {
  final Database db = await database;
  await db.delete(
    'accounts',
    where: 'account_id = ?',
    whereArgs: [accountId]
  );
}