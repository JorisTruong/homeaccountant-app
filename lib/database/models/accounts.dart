class Account {
  final int accountId;
  final String accountName;
  final String accountAcronym;
  final String accountCountryIso;

  Account({this.accountId, this.accountName, this.accountAcronym, this.accountCountryIso});

  Map<String, dynamic> toMap() {
    return {
      'account_id': accountId,
      'account_name': accountName,
      'account_acronym': accountAcronym,
      'account_country': accountCountryIso
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'account_name': accountName,
      'account_acronym': accountAcronym,
      'account_country': accountCountryIso
    };
  }

  @override
  String toString() {
    return 'Account{account_id: $accountId, account_name: $accountName, account_acronym: $accountAcronym, account_country: $accountCountryIso}';
  }
}