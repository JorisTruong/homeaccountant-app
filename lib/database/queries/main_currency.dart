import 'package:sqflite/sqflite.dart';
import 'dart:async';

///
/// Queries related to the main currency
///

// READ
Future<Map<String, dynamic>> readMainCurrency(Database db) async {
  final List<Map<String, dynamic>> mainCurrency = (await db.rawQuery('SELECT * FROM main_currency WHERE id = ?', [0]));
  return mainCurrency[0];
}

// UPDATE
Future<void> updateMainCurrency(Database db, Map<String, dynamic> updatedMainCurrency) async {
  await db.update(
    'main_currency',
    updatedMainCurrency,
    where: 'id = ?',
    whereArgs: [0]
  );
}