class Holding {
  final String coinId;
  final String coinName;
  final String coinSymbol;
  double quantity;

  Holding({
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.quantity,
  });

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      coinId: json['coinId'],
      coinName: json['coinName'],
      coinSymbol: json['coinSymbol'],
      quantity: (json['quantity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'coinId': coinId,
        'coinName': coinName,
        'coinSymbol': coinSymbol,
        'quantity': quantity,
      };
}
