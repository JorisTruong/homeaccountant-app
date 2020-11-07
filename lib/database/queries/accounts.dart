import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart';

///
/// Queries related to the 'Accounts' entity
///

// CREATE
Future<void> createAccount(Database db, Account account) async {
  await db.insert('accounts', account.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.ignore);
}

// READ ALL
Future<List<Account>> readAccounts(Database db) async {
  final List<Map<String, dynamic>> accounts = await db.query('accounts');
  return List.generate(accounts.length, (i) {
    return Account(
      accountId: accounts[i]['account_id'],
      accountName: accounts[i]['account_name'],
      accountAcronym: accounts[i]['account_acronym'],
      accountCountryIso: accounts[i]['account_country'],
      accountCurrency: accounts[i]['account_currency']
    );
  });
}

// READ ONE
Future<List<Account>> accountFromId(Database db, List<int> accountId) async {
  final List<Map<String, dynamic>> accounts = (await db.rawQuery('SELECT * FROM accounts WHERE account_id IN (${accountId.map((e) => '?').join(', ')})', [...accountId]));
  if (accounts.length > 0) {
    return List.generate(accounts.length, (i) {
      return Account(
        accountId: accounts[i]['account_id'],
        accountName: accounts[i]['account_name'],
        accountAcronym: accounts[i]['account_acronym'],
        accountCountryIso: accounts[i]['account_country'],
        accountCurrency: accounts[i]['account_currency']
      );
    });
  } else {
    return null;
  }
}

// UPDATE
Future<void> updateAccount(Database db, Account updatedAccount) async {
  await db.update(
    'accounts',
    updatedAccount.toMap(),
    where: 'account_id = ?',
    whereArgs: [updatedAccount.accountId]
  );
}

// DELETE
Future<void> deleteAccount(Database db, int accountId) async {
  await db.delete(
    'accounts',
    where: 'account_id = ?',
    whereArgs: [accountId]
  );
}