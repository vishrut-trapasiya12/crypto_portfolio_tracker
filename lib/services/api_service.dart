import 'dart:convert';
import 'dart:developer';
import 'package:crypto_portfolio/models/coin.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String base = 'https://api.coingecko.com/api/v3';

  static Future<List<Coin>> fetchCoinList() async {
    final uri = Uri.parse('$base/coins/list');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      return data.map((e) => Coin.fromJson(e)).toList();
    } else {
      log("Error", name: "fetchCoinList");
      throw Exception('Failed to fetch coin list');
    }
  }

  static Future<Map<String, double>> fetchPrices(List<String> coinIds) async {
    if (coinIds.isEmpty) return {};
    final ids = coinIds.join(',');
    final uri = Uri.parse('$base/simple/price?ids=$ids&vs_currencies=usd');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(res.body);
      final Map<String, double> prices = {};
      data.forEach((key, value) {
        final price = (value['usd'] as num?)?.toDouble() ?? 0.0;
        prices[key] = price;
      });
      return prices;
    } else {
      log("fetchPrices", name: "fetchCoinList");
      throw Exception('Failed to fetch prices');
    }
  }
}
