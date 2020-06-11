import 'dart:math';


/// Homepage

// Currency
final String currency = 'EUR';

// Get transactions, group all transactions and sum value
final String balance = '250,000';

// Get transactions, group all transactions where is_expense = 1 and sum value
final String expensesAll = '80,000';

// Get transactions, group all transactions where is_expense = 0 and sum value
final String revenueAll = '330,000';

// Get transactions, group all transactions and sum count
final String transactionNumber = '42';


/// Categories

final random = Random();

// TODO: Renaming, store categories ?
List<Map<String, dynamic>> categories_ = [];

// Get all subcategories
// TODO: Store subcategories ?

/// Transactions


/// Graphs

/// Line chart revenue
// 7, 4 or 12 API calls (week, month or year) on transactions where is_expense = 1, group by date/week/month and sum
List<double> revenueWeek = [
  200000,
  100000,
  30000,
  0,
  0,
  0,
  0
];

/// Line chart expenses
// 7, 4 or 12 API calls (week, month or year) on transactions where is_expense = 0, group by date/week/month and sum
List<double> expensesWeek = [
  0,
  0,
  20000,
  0,
  0,
  50000,
  10000
];

/// Line chart balance
// 7, 4 or 12 API calls (week, month or year) on transactions group by date/week/month and cum sum
List<double> balanceWeek = [
  200000,
  300000,
  310000,
  310000,
  310000,
  260000,
  250000
];


/// ACCOUNTS

// Get all accounts
// TODO: Review, store accounts ?
List<Map<String, dynamic>> accounts = [];