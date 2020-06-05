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
// Get all transactions
// TODO: Review how to reorganize by month-year
final transactions = {
  'March 2020': [
    {
      'id': 0,
      'transaction_name': 'Salary',
      'account_id': 1,
      'date': '2020-03-02',
      'is_expense': 0,
      'amount': 3000,
      'description': '',
      'category_id': 0,
    },
    {
      'id': 1,
      'transaction_name': 'Shoes',
      'account_id': 1,
      'date': '2020-03-31',
      'is_expense': 1,
      'amount': 80,
      'description': '',
      'category_id': 2,
    },
    {
      'id': 2,
      'transaction_name': 'Clothes',
      'account_id': 1,
      'date': '2020-03-31',
      'is_expense': 1,
      'amount': 200,
      'description': '',
      'category_id': 2,
    }
  ],
  'April 2020': [
    {
      'id': 3,
      'transaction_name': 'Pho',
      'account_id': 1,
      'date': '2020-04-01',
      'is_expense': 1,
      'amount': 10,
      'description': '',
      'category_id': 3,
    },
    {
      'id': 4,
      'transaction_name': 'KBBQ',
      'account_id': 1,
      'date': '2020-04-01',
      'is_expense': 1,
      'amount': 30,
      'description': '',
      'category_id': 4,
    },
    {
      'id': 5,
      'transaction_name': 'Sandwich',
      'account_id': 1,
      'date': '2020-04-01',
      'is_expense': 1,
      'amount': 5,
      'description': 'Triangle',
      'category_id': 1,
    },
  ]
};


/// Graphs

// Get transactions where is_expense = 1, group by categories, sum by value (and compute percentage in back-end ?)
final expenses = [
  {'name': 'Category 1', 'percentage': 40},
  {'name': 'Category 2', 'percentage': 10},
  {'name': 'Category 3', 'percentage': 17},
  {'name': 'Category 4', 'percentage': 13},
  {'name': 'Category 5', 'percentage': 20}
];

// Get transactions where is_expense = 0, group by categories, sum by value (and compute percentage in back-end ?)
final revenue = [
  {'name': 'Category 1', 'percentage': 90},
  {'name': 'Category 2', 'percentage': 10},
  {'name': 'Category 3', 'percentage': 0},
  {'name': 'Category 4', 'percentage': 0},
  {'name': 'Category 5', 'percentage': 0}
];

/// Bar chart dual and multi-types
// 7, 4 or 12 API calls (week, month or year) on transactions where is_expense = 1, group by category and date/week/month and sum
// 7, 4 or 12 API calls (week, month or year) on transactions where is_expense = 0, group by category and date/week/month and sum
final transactionsDetailed = [
  {'revenue': [120000.0, 5000.0, 24000.0, 0.0, 51000.0], 'expenses': [50000.0, 0.0, 0.0, 0.0, 0.0]},
  {'revenue': [20000.0, 20000.0, 20000.0, 20000.0, 20000.0], 'expenses': [13000.0, 7000.0, 0.0, 30000.0, 17000.0]},
  {'revenue': [0.0, 0.0, 30000.0, 0.0, 0.0], 'expenses': [0.0, 10000.0, 0.0, 0.0, 10000.0]},
  {'revenue': [54000.0, 0.0, 6000.0, 28000.0, 32000.0], 'expenses': [0.0, 100000.0, 80000.0, 0.0, 0.0]},
  {'revenue': [0.0, 0.0, 60000.0, 60000.0, 60000.0], 'expenses': [7500.0, 0.0, 500.0, 10.0, 6990.0]},
  {'revenue': [20000.0, 0.0, 0.0, 0.0, 10000.0], 'expenses': [10.0000, 10000.0, 10000.0, 10000.0, 10000.0]},
  {'revenue': [1000.0, 1000.0, 8000.0, 0.0, 10000.0], 'expenses': [500.0, 500.0, 6500.0, 1500.0, 1000.0]}
];

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