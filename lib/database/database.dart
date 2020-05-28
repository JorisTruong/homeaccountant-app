import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart';
import 'package:homeaccountantapp/database/queries/queries.dart';
import 'package:homeaccountantapp/data.dart';


class DatabaseClient {
  Database db;

  Future<void> createTables(Database database) async {
    await database.execute(
      'CREATE TABLE accounts(account_id INTEGER PRIMARY KEY, account_name TEXT, account_acronym TEXT)'
    );
  }

  Future<void> create() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'home_accountant.db'),
      onCreate: (db, version) {
        createTables(db);
      },
      version: 1
    );

    // Initialize 'Accounts'
    Account basicAccount = Account(
        accountId: 0,
        accountName: 'Account 1',
        accountAcronym: 'ACC1'
    );
    await createAccount(db, basicAccount);

    accounts = (await readAccounts(db)).map((account) {
      return account.toMap();
    }).toList();
  }
}