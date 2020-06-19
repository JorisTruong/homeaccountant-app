import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart' as models;
import 'package:homeaccountantapp/database/queries/transactions.dart';

///
/// Queries related to the 'Subcategories' entity
///

// CREATE
Future<void> createSubcategory(Database db, models.Subcategory subcategory) async {
  await db.insert('subcategories', subcategory.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.ignore);
}

// TODO: Needed ?
// READ ALL
Future<List<models.Subcategory>> readSubcategories(Database db) async {
  final List<Map<String, dynamic>> subcategories = await db.query('subcategories');
  return List.generate(subcategories.length, (i) {
    return models.Subcategory(
      subcategoryId: subcategories[i]['subcategory_id'],
      categoryId: subcategories[i]['category_id'],
      subcategoryName: subcategories[i]['subcategory_name'],
      subcategoryIconId: subcategories[i]['subcategory_icon_id']
    );
  });
}

// READ ONE
Future<models.Subcategory> subcategoryFromId(Database db, int subcategoryId) async {
  final List<Map<String, dynamic>> subcategory = (await db.rawQuery('SELECT * FROM subcategories WHERE subcategory_id=?', [subcategoryId]));
  if (subcategory.length > 0) {
    return models.Subcategory(
      subcategoryId: subcategory[0]['subcategory_id'],
      categoryId: subcategory[0]['category_id'],
      subcategoryName: subcategory[0]['subcategory_name'],
      subcategoryIconId: subcategory[0]['subcategory_icon_id']
    );
  } else {
    return null;
  }
}

// READ ALL OF SAME CATEGORY
Future<List<models.Subcategory>> subcategoriesFromCategoryId(Database db, int categoryId) async {
  final List<Map<String, dynamic>> subcategories = await db.rawQuery('SELECT * FROM subcategories WHERE category_id=?', [categoryId]);
  return List.generate(subcategories.length, (i) {
    return models.Subcategory(
      subcategoryId: subcategories[i]['subcategory_id'],
      categoryId: subcategories[i]['category_id'],
      subcategoryName: subcategories[i]['subcategory_name'],
      subcategoryIconId: subcategories[i]['subcategory_icon_id']
    );
  });
}

// UPDATE
Future<void> updateSubcategory(Database db, models.Subcategory updatedSubcategory) async {
  await db.update(
    'subcategories',
    updatedSubcategory.toMap(),
    where: 'subcategory_id = ?',
    whereArgs: [updatedSubcategory.subcategoryId],
  );
}

// DELETE
Future<void> deleteSubcategory(Database db, int subcategoryId) async {
  List<models.Transaction> transactionsToUpdate = await getTransactionFromSubcategoryId(db, subcategoryId);
  for (var transaction in transactionsToUpdate) {
    models.Transaction updatedTransaction = models.Transaction(
      transactionId: transaction.transactionId,
      transactionName: transaction.transactionName,
      accountId: transaction.accountId,
      date: transaction.date,
      isExpense: transaction.isExpense,
      amount: transaction.amount,
      description: transaction.description,
      categoryId: transaction.categoryId,
      subcategoryId: null
    );
    await updateTransaction(db, updatedTransaction);
  }
  await db.delete(
    'subcategories',
    where: 'subcategory_id = ?',
    whereArgs: [subcategoryId]
  );
}