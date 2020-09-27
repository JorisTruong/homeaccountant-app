class ExchangeRate {
  final int exchangeRateId;
  final String from;
  final String to;
  final double rate;
  final String date;

  ExchangeRate({this.exchangeRateId, this.from, this.to, this.rate, this.date});

  Map<String, dynamic> toMap() {
    return {
      'exchange_rate_id': exchangeRateId,
      'from': from,
      'to': to,
      'rate': rate,
      'date': date
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'from': from,
      'to': to,
      'rate': rate,
      'date': date
    };
  }

  @override
  String toString() {
    return 'ExchangeRate{exchange_rate_id: $exchangeRateId, from: $from, to: $to, rate: $rate, date, $date}';
  }
}