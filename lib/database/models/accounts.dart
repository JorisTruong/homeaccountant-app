class Account {
  final int accountId;
  final String accountName;
  final String accountAcronym;

  Account({this.accountId, this.accountName, this.accountAcronym});

  Map<String, dynamic> toMap() {
    return {
      'account_id': accountId,
      'account_name': accountName,
      'account_acronym': accountAcronym
    };
  }

  @override
  String toString() {
    return 'Account{account_id: $accountId, account_name: $accountName, account_acronym: $accountAcronym}';
  }
}