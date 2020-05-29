import 'package:homeaccountantapp/database/queries/categories.dart';
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
    await database.execute(
      'CREATE TABLE categories(category_id INTEGER PRIMARY KEY, category_name TEXT, category_icon_id INTEGER)'
    );
  }

  Future<void> initializeAccounts() async {
    Account basicAccount = Account(
      accountId: 0,
      accountName: 'Account 1',
      accountAcronym: 'ACC1'
    );
    await createAccount(db, basicAccount);

    var allAccounts = await readAccounts(db);
    accounts = List.generate(allAccounts.length, (int i) {
      return allAccounts[i].toMap();
    });
  }

  Future<void> initializeCategories() async {
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
    batch.insert('Categories', category1.toMap());
    batch.insert('Categories', category2.toMap());
    batch.insert('Categories', category3.toMap());
    batch.insert('Categories', category4.toMap());
    batch.insert('Categories', category5.toMap());
    await batch.commit();

    var allCategories = await readCategories(db);
    categories_ = List.generate(allCategories.length, (int i) {
      return allCategories[i].toMap();
    });
  }

  Future<void> create() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'home_accountant.db'),
      onCreate: (db, version) {
        createTables(db);
      },
      version: 1
    );

    initializeAccounts();
    initializeCategories();
  }
}