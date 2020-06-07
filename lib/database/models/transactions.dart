class Transaction {
  final int transactionId;
  final String transactionName;
  final int accountId;
  final String date;
  final bool isExpense;
  final double amount;
  final String description;
  final int categoryId;
  final int subcategoryId;

  Transaction({
    this.transactionId,
    this.transactionName,
    this.accountId,
    this.date,
    this.isExpense,
    this.amount,
    this.description,
    this.categoryId,
    this.subcategoryId
  });

  Map<String, dynamic> toMap() {
    return {
      'transaction_id': transactionId,
      'transaction_name': transactionName,
      'account_id': accountId,
      'date': date,
      'is_expense': isExpense ? 1 : 0,
      'amount': amount,
      'description': description,
      'category_id': categoryId,
      'subcategory_id': subcategoryId
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'transaction_name': transactionName,
      'account_id': accountId,
      'date': date,
      'is_expense': isExpense ? 1 : 0,
      'amount': amount,
      'description': description,
      'category_id': categoryId,
      'subcategory_id': subcategoryId
    };
  }

  @override
  String toString() {
    return 'Transaction{transaction_id: $transactionId, ' +
      'transaction_name: $transactionName, ' +
      'account_id: $accountId, ' +
      'date: $date, ' +
      'is_expense: $isExpense, ' +
      'amount : $amount, ' +
      'description : $description, ' +
      'category_id : $categoryId, ' +
      'subcategory_id : $subcategoryId';
  }
}