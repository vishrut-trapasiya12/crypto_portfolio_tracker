import 'dart:async';
import 'dart:developer';

import 'package:crypto_portfolio/models/coin.dart';
import 'package:crypto_portfolio/models/holding.dart';
import 'package:crypto_portfolio/services/api_service.dart';
import 'package:crypto_portfolio/services/storage_service.dart';
import 'package:get/get.dart';

class PortfolioController extends GetxController {
  final RxMap<String, Coin> coinMap = <String, Coin>{}.obs;
  final RxList<Coin> coinList = <Coin>[].obs;

  final RxList<Holding> portfolio = <Holding>[].obs;

  final RxMap<String, double> prices = <String, double>{}.obs;

  final RxMap<String, double> previousPrices = <String, double>{}.obs;

  final RxBool loadingCoins = false.obs;
  final RxBool loadingPrices = false.obs;
  final RxString error = ''.obs;

  Timer? _autoRefreshTimer;

  @override
  void onInit() {
    super.onInit();
    loadSavedPortfolio();
    fetchCoinList();
    startAutoRefresh();
  }

  @override
  onClose() {
    stopAutoRefresh();
  }

  Future<void> fetchCoinList() async {
    try {
      loadingCoins.value = true;
      error.value = '';
      final coins = await ApiService.fetchCoinList();
      coinList.assignAll(coins);
      final Map<String, Coin> m = {};
      for (var c in coins) {
        m[c.id] = c;
      }
      coinMap.assignAll(m);
    } catch (e) {
      log(e.toString(), name: "fetchCoinList");
      error.value = e.toString();
    } finally {
      loadingCoins.value = false;
    }
  }

  Future<void> loadSavedPortfolio() async {
    final saved = await StorageService.loadPortfolio();
    portfolio.assignAll(saved);

    final savedPrices = await StorageService.loadPrices();
    log(savedPrices.toString());
    prices.assignAll(savedPrices);

    if (portfolio.isNotEmpty && prices.isEmpty) {
      await fetchPricesForPortfolio();
    }
  }

  Future<void> fetchPricesForPortfolio() async {
    if (portfolio.isEmpty) {
      prices.clear();
      return;
    }
    try {
      loadingPrices.value = true;
      error.value = '';

      final coinIds = portfolio.map((p) => p.coinId).toList();
      final fetchPrices = await ApiService.fetchPrices(coinIds);

      previousPrices.assignAll(prices);

      prices.assignAll(fetchPrices);

      await StorageService.savePrices(prices);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loadingPrices.value = false;
    }
  }

  bool? priceChangeColor(String coinId) {
    final oldPrice = previousPrices[coinId] ?? 0.0;
    final newPrice = prices[coinId] ?? 0.0;

    if (newPrice > oldPrice) return true;
    if (newPrice < oldPrice) return false;
    return null;
  }

  Future<void> addOrUpdateHolding(Holding holding) async {
    final idx = portfolio.indexWhere((p) => p.coinId == holding.coinId);
    if (idx >= 0) {
      portfolio[idx].quantity += holding.quantity;
      portfolio.refresh();
    } else {
      portfolio.add(holding);
    }
    await StorageService.savePortfolio(portfolio);
    await fetchPricesForPortfolio();
  }

  Future<void> removeHolding(String coinId) async {
    portfolio.removeWhere((p) => p.coinId == coinId);
    await StorageService.savePortfolio(portfolio);
    prices.remove(coinId);
  }

  double holdingValue(Holding h) {
    final price = prices[h.coinId] ?? 0.0;
    return h.quantity * price;
  }

  double totalPortfolioValue() {
    double sum = 0.0;
    for (var h in portfolio) {
      sum += holdingValue(h);
    }
    return sum;
  }

  List<Coin> searchCoins(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final results = coinList.where((c) {
      final name = c.name.toLowerCase();
      final symbol = c.symbol.toLowerCase();
      return name.contains(q) || symbol.contains(q);
    }).toList();
    return results;
  }

  void startAutoRefresh({int minutes = 2}) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(Duration(minutes: minutes), (_) {
      fetchPricesForPortfolio();
      log("Fetched fetchPricesForPortfolio", name: "startAutoRefresh");
    });
  }

  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }
}
