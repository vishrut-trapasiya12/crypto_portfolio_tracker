import 'dart:convert';
import 'package:crypto_portfolio/models/holding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyPortfolio = 'portfolio_v1';
  static const String _keyPrices = 'prices_v1';

  /// Save portfolio list
  static Future<void> savePortfolio(List<Holding> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((h) => h.toJson()).toList();
    await prefs.setString(_keyPortfolio, json.encode(jsonList));
  }

  /// Load portfolio list
  static Future<List<Holding>> loadPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyPortfolio);
    if (raw == null) return [];
    try {
      final List<dynamic> data = json.decode(raw);
      return data.map((e) => Holding.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear portfolio
  static Future<void> clearPortfolio() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPortfolio);
  }

  /// Save prices map (coinId -> price)
  static Future<void> savePrices(Map<String, double> prices) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPrices, json.encode(prices));
  }

  /// Load prices map
  static Future<Map<String, double>> loadPrices() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyPrices);
    if (raw == null) return {};
    try {
      final Map<String, dynamic> data = json.decode(raw);
      return data.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } catch (e) {
      return {};
    }
  }

  /// Clear saved prices
  static Future<void> clearPrices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPrices);
  }
}
