import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart';

///
/// Queries related to the 'Subcategories' entity
///

// CREATE
Future<void> createSubcategory(Database db, Subcategory subcategory) async {
  await db.insert('subcategories', subcategory.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.ignore);
}

// TODO: Needed ?
// READ ALL
Future<List<Subcategory>> readSubcategories(Database db) async {
  final List<Map<String, dynamic>> subcategories = await db.query('subcategories');
  return List.generate(subcategories.length, (i) {
    return Subcategory(
      subcategoryId: subcategories[i]['subcategory_id'],
      categoryId: subcategories[i]['category_id'],
      subcategoryName: subcategories[i]['subcategory_name'],
      subcategoryIconId: subcategories[i]['subcategory_icon_id']
    );
  });
}

// READ ONE
Future<Subcategory> subcategoryFromId(Database db, int subcategoryId) async {
  final List<Map<String, dynamic>> subcategory = (await db.rawQuery('SELECT * FROM subcategories WHERE subcategory_id=?', [subcategoryId]));
  if (subcategory.length > 0) {
    return Subcategory(
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
Future<List<Subcategory>> subcategoriesFromCategoryId(Database db, int categoryId) async {
  final List<Map<String, dynamic>> subcategories = await db.rawQuery('SELECT * FROM subcategories WHERE category_id=?', [categoryId]);
  return List.generate(subcategories.length, (i) {
    return Subcategory(
      subcategoryId: subcategories[i]['subcategory_id'],
      categoryId: subcategories[i]['category_id'],
      subcategoryName: subcategories[i]['subcategory_name'],
      subcategoryIconId: subcategories[i]['subcategory_icon_id']
    );
  });
}

// UPDATE
Future<void> updateSubcategory(Database db, Subcategory updatedSubcategory) async {
  await db.update(
    'subcategories',
    updatedSubcategory.toMap(),
    where: 'subcategory_id = ?',
    whereArgs: [updatedSubcategory.subcategoryId],
  );
}

// DELETE
Future<void> deleteSubcategory(Database db, int subcategoryId) async {
  await db.delete(
    'subcategories',
    where: 'subcategory_id = ?',
    whereArgs: [subcategoryId]
  );
}