import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:homeaccountantapp/database/models/models.dart';

///
/// Queries related to the 'ExchangeRate' entity
///

// CREATE
Future<void> createExchangeRate(Database db, ExchangeRate exchangeRate) async {
  await db.insert('exchange_rates', exchangeRate.toMapWithoutId(), conflictAlgorithm: ConflictAlgorithm.ignore);
}

// READ ALL
Future<List<ExchangeRate>> readExchangeRates(Database db) async {
  final List<Map<String, dynamic>> exchangeRates = await db.query('exchange_rates');
  return List.generate(exchangeRates.length, (i) {
    return ExchangeRate(
      exchangeRateId: exchangeRates[i]['exchange_rate_id'],
      from: exchangeRates[i]['from'],
      to: exchangeRates[i]['to'],
      rate: exchangeRates[i]['rate'],
      date: exchangeRates[i]['date']
    );
  });
}


// READ ONE
Future<ExchangeRate> readExchangeRate(Database db, String from, String to) async {
  final List<Map<String, dynamic>> exchangeRate = (await db.rawQuery('SELECT * FROM exchange_rates WHERE `from`=? and `to`=?', [from, to]));
  if (exchangeRate.length > 0) {
    return ExchangeRate(
      exchangeRateId: exchangeRate[0]['exchange_rate_id'],
      from: exchangeRate[0]['from'],
      to: exchangeRate[0]['to'],
      rate: exchangeRate[0]['rate'],
      date: exchangeRate[0]['date']
    );
  } else {
    return null;
  }
}

// UPDATE
Future<void> updateExchangeRate(Database db, ExchangeRate updatedExchangeRate) async {
  await db.update(
    'exchange_rates',
    updatedExchangeRate.toMap(),
    where: 'exchange_rate_id = ?',
    whereArgs: [updatedExchangeRate.exchangeRateId]
  );
}

// DELETE
Future<void> deleteExchangeRate(Database db, int exchangeRateId) async {
  await db.delete(
    'exchange_rates',
    where: 'exchange_rate_id = ?',
    whereArgs: [exchangeRateId]
  );
}
