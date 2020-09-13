import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart';


class DatabaseClient {
  Database db;

  Future<void> createTables(Database database) {
    database.execute(
      'CREATE TABLE accounts(' +
        'account_id INTEGER PRIMARY KEY AUTOINCREMENT,' +
        'account_name TEXT,' +
        'account_acronym TEXT,' +
        'account_country TEXT' +
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
    database.execute(
      'CREATE TABLE main_currency(id INTEGER PRIMARY KEY, country_iso TEXT, currency TEXT)'
    );
    return null;
  }

  Future<void> initializeMainCurrency(Database db) async {
    Map<String, dynamic> mainCurrency = {
      'id': 0,
      'country_iso': 'FR',
      'currency': 'EUR'
    };
    Batch batch = db.batch();
    batch.insert('main_currency', mainCurrency);
    batch.commit();
  }

  Future<void> initializeAccounts(Database db) async {
    Account basicAccount = Account(
      accountId: 1,
      accountName: 'Account 1',
      accountAcronym: 'ACC1',
      accountCountryIso: 'FR'
    );
    Batch batch = db.batch();
    batch.insert('accounts', basicAccount.toMap());
    batch.commit();
  }

  Future<void> initializeCategories(Database db) async {
    Category income = Category(
      categoryId: 0,
      categoryName: 'Income',
      categoryIconId: 601
    );
    Category food = Category(
      categoryId: 1,
      categoryName: 'Food',
      categoryIconId: 505
    );
    Category house = Category(
      categoryId: 2,
      categoryName: 'House',
      categoryIconId: 430
    );
    Category health = Category(
      categoryId: 3,
      categoryName: 'Health',
      categoryIconId: 308
    );
    Category transportation = Category(
      categoryId: 4,
      categoryName: 'Transport',
      categoryIconId: 257
    );
    Category shopping = Category(
      categoryId: 5,
      categoryName: 'Shopping',
      categoryIconId: 793
    );
    Category others = Category(
      categoryId: 6,
      categoryName: 'Others',
      categoryIconId: 941
    );

    Batch batch = db.batch();
    batch.insert('categories', income.toMap());
    batch.insert('categories', food.toMap());
    batch.insert('categories', house.toMap());
    batch.insert('categories', health.toMap());
    batch.insert('categories', transportation.toMap());
    batch.insert('categories', shopping.toMap());
    batch.insert('categories', others.toMap());
    batch.commit();
  }

  Future<void> initializeSubcategories(Database db) async {
    Subcategory salary = Subcategory(
      subcategoryId: 0,
      categoryId: 0,
      subcategoryName: 'Salary',
      subcategoryIconId: 565
    );
    Subcategory bonus = Subcategory(
      subcategoryId: 1,
      categoryId: 0,
      subcategoryName: 'Bonus',
      subcategoryIconId: 684
    );
    Subcategory restaurant = Subcategory(
      subcategoryId: 2,
      categoryId: 1,
      subcategoryName: 'Restaurant',
      subcategoryIconId: 732
    );
    Subcategory rent = Subcategory(
      subcategoryId: 3,
      categoryId: 2,
      subcategoryName: 'Rent',
      subcategoryIconId: 430
    );
    Subcategory waterBill = Subcategory(
      subcategoryId: 4,
      categoryId: 2,
      subcategoryName: 'Water bill',
      subcategoryIconId: 611
    );
    Subcategory electricityBill = Subcategory(
      subcategoryId: 5,
      categoryId: 2,
      subcategoryName: 'Electricity bill',
      subcategoryIconId: 349
    );
    Subcategory doctor = Subcategory(
      subcategoryId: 6,
      categoryId: 3,
      subcategoryName: 'Doctor',
      subcategoryIconId: 510
    );
    Subcategory medicines = Subcategory(
      subcategoryId: 7,
      categoryId: 3,
      subcategoryName: 'Medicines',
      subcategoryIconId: 422
    );
    Subcategory fuel = Subcategory(
      subcategoryId: 8,
      categoryId: 4,
      subcategoryName: 'Fuel',
      subcategoryIconId: 508
    );
    Subcategory charging = Subcategory(
      subcategoryId: 9,
      categoryId: 4,
      subcategoryName: 'Recharge',
      subcategoryIconId: 286
    );
    Subcategory metro = Subcategory(
      subcategoryId: 10,
      categoryId: 4,
      subcategoryName: 'Metro',
      subcategoryIconId: 851
    );
    Subcategory taxi = Subcategory(
      subcategoryId: 11,
      categoryId: 4,
      subcategoryName: 'Taxi',
      subcategoryIconId: 526
    );
    Subcategory parking = Subcategory(
      subcategoryId: 12,
      categoryId: 4,
      subcategoryName: 'Parking',
      subcategoryIconId: 517
    );
    Subcategory groceries = Subcategory(
      subcategoryId: 13,
      categoryId: 5,
      subcategoryName: 'Groceries',
      subcategoryIconId: 840
    );
    Subcategory clothes = Subcategory(
      subcategoryId: 14,
      categoryId: 5,
      subcategoryName: 'Clothes',
      subcategoryIconId: 514
    );
    Subcategory transfer = Subcategory(
      subcategoryId: 15,
      categoryId: 6,
      subcategoryName: 'Transfer',
      subcategoryIconId: 201
    );
    Subcategory atm = Subcategory(
    subcategoryId: 16,
    categoryId: 6,
    subcategoryName: 'ATM',
    subcategoryIconId: 78
    );

    Batch batch = db.batch();
    batch.insert('subcategories', salary.toMap());
    batch.insert('subcategories', bonus.toMap());
    batch.insert('subcategories', restaurant.toMap());
    batch.insert('subcategories', rent.toMap());
    batch.insert('subcategories', waterBill.toMap());
    batch.insert('subcategories', electricityBill.toMap());
    batch.insert('subcategories', doctor.toMap());
    batch.insert('subcategories', medicines.toMap());
    batch.insert('subcategories', fuel.toMap());
    batch.insert('subcategories', charging.toMap());
    batch.insert('subcategories', metro.toMap());
    batch.insert('subcategories', taxi.toMap());
    batch.insert('subcategories', parking.toMap());
    batch.insert('subcategories', groceries.toMap());
    batch.insert('subcategories', clothes.toMap());
    batch.insert('subcategories', transfer.toMap());
    batch.insert('subcategories', atm.toMap());
    batch.commit();
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> create() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'home_accountant.db'),
      onCreate: (db, version) async {
        await createTables(db);
        await initializeMainCurrency(db);
        await initializeAccounts(db);
        await initializeCategories(db);
        await initializeSubcategories(db);
      },
      onConfigure: (db) {
        _onConfigure(db);
      },
      version: 1
    );
  }
}

DatabaseClient databaseClient = DatabaseClient();