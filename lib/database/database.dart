import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart';
import 'package:homeaccountantapp/database/queries/queries.dart';
import 'package:homeaccountantapp/data.dart';


class DatabaseClient {
  Database db;

  Future<void> createTables(Database database) {
    database.execute(
      'CREATE TABLE accounts(' +
        'account_id INTEGER PRIMARY KEY AUTOINCREMENT,' +
        'account_name TEXT,' +
        'account_acronym TEXT' +
      ')'
    );
    database.execute(
      'CREATE TABLE categories(' +
        'category_id INTEGER PRIMARY KEY,' +
        'category_name TEXT,' +
        'category_icon_id INTEGER' +
      ')'
    );
    database.execute(
      'CREATE TABLE subcategories(' +
        'subcategory_id INTEGER PRIMARY KEY AUTOINCREMENT,' +
        'category_id INTEGER,' +
        'subcategory_name TEXT,' +
        'subcategory_icon_id INTEGER,' +
        'FOREIGN KEY (category_id) REFERENCES categories (category_id)' +
      ')'
    );
    database.execute(
      'CREATE TABLE transactions(' +
        'transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,' +
        'transaction_name TEXT,' +
        'account_id INTEGER,' +
        'date TEXT,' +
        'is_expense INTEGER,' +
        'amount REAL,' +
        'description TEXT,' +
        'category_id INTEGER,' +
        'subcategory_id INTEGER,' +
        'FOREIGN KEY (account_id) REFERENCES accounts (account_id),' +
        'FOREIGN KEY (category_id) REFERENCES categories (category_id),' +
        'FOREIGN KEY (subcategory_id) REFERENCES subcategories (subcategory_id)' +
      ')'
    );
    return null;
  }

  Future<void> initializeAccounts(Database db) async {
    Account basicAccount = Account(
      accountId: 1,
      accountName: 'Account 1',
      accountAcronym: 'ACC1'
    );
    Batch batch = db.batch();
    batch.insert('accounts', basicAccount.toMap());
    batch.commit();
  }

  Future<void> initializeCategories(Database db) async {
    // Initialize 'Categories'
    Category category1 = Category(
      categoryId: 0,
      categoryName: 'Category 1',
      categoryIconId: 0
    );
    Category category2 = Category(
      categoryId: 1,
      categoryName: 'Category 2',
      categoryIconId: 0
    );
    Category category3 = Category(
      categoryId: 2,
      categoryName: 'Category 3',
      categoryIconId: 0
    );
    Category category4 = Category(
      categoryId: 3,
      categoryName: 'Category 4',
      categoryIconId: 0
    );
    Category category5 = Category(
      categoryId: 4,
      categoryName: 'Category 5',
      categoryIconId: 0
    );
    Batch batch = db.batch();
    batch.insert('categories', category1.toMap());
    batch.insert('categories', category2.toMap());
    batch.insert('categories', category3.toMap());
    batch.insert('categories', category4.toMap());
    batch.insert('categories', category5.toMap());
    batch.commit();

    var allCategories = await readCategories(db);
    categories = List.generate(allCategories.length, (int i) {
      return allCategories[i].toMap();
    });
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> create() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'home_accountant.db'),
      onCreate: (db, version) async {
        await createTables(db);
        await initializeAccounts(db);
        await initializeCategories(db);
      },
      onConfigure: (db) {
        _onConfigure(db);
      },
      version: 1
    );
  }
}

DatabaseClient databaseClient = DatabaseClient();