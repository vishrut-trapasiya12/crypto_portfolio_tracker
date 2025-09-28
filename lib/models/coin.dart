class Coin {
  final String id;
  final String symbol;
  final String name;

  Coin({required this.id, required this.symbol, required this.name});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'name': name,
      };
}
