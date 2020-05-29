import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart';

///
/// Queries related to the 'Categories' entity
///

// READ ALL
Future<List<Category>> readCategories(Database db) async {
  final List<Map<String, dynamic>> categories = await db.query('categories');
  return List.generate(categories.length, (i) {
    return Category(
      categoryId: categories[i]['category_id'],
      categoryName: categories[i]['category_name'],
      categoryIconId: categories[i]['category_icon_id']
    );
  });
}

// READ ONE
Future<Category> categoryFromId(Database db, int categoryId) async {
  final Map<String, dynamic> category = (await db.rawQuery('SELECT * FROM categories WHERE category_id=?', [categoryId]))[0];
  return Category(
    categoryId: category['category_id'],
    categoryName: category['category_name'],
    categoryIconId: category['category_icon_id']
  );
}