import 'package:crypto_portfolio/controllers/portfolio_controller.dart';
import 'package:crypto_portfolio/models/holding.dart';
import 'package:crypto_portfolio/theme/app_colors.dart';
import 'package:crypto_portfolio/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAssetsController extends GetxController {
  final PortfolioController portfolioController =
      Get.find<PortfolioController>();
  final TextEditingController searchctl = TextEditingController();
  final TextEditingController qtyctl = TextEditingController();
  List results = [];
  String? selectedCoinId;
  String? selectedName;
  String? selectedSymbol;
  bool searching = false;
  bool isEnable = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCoinList();
    });
  }

  Future<void> _loadCoinList() async {
    if (portfolioController.coinList.isEmpty) {
      await portfolioController.fetchCoinList();
    }
    results = portfolioController.coinList;
    update();
  }

  void selectCoin(AddAssetsController controller, coin) {
    selectedCoinId = coin.id;
    selectedName = coin.name;
    selectedSymbol = coin.symbol;
    update();
  }

  bool checkEnable() {
    final qty = double.tryParse(qtyctl.text);
    if (selectedCoinId == null) {
      return false;
    }
    if (qty == null || qty <= 0) {
      return false;
    }
    update();
    return true;
  }

  void onSearch(String q) {
    searching = true;
    update();

    if (q.trim().isEmpty) {
      results = portfolioController.coinList;
    } else {
      results = portfolioController.searchCoins(q);
    }

    searching = false;
    update();
  }

  Future<void> save() async {
    final qty = double.tryParse(qtyctl.text);
    if (selectedCoinId == null) {
      Get.snackbar('Select coin', 'Please select a coin',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (qty == null || qty <= 0) {
      Get.snackbar('Quantity', 'Enter a valid quantity',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final holding = Holding(
      coinId: selectedCoinId!,
      coinName: selectedName ?? '',
      coinSymbol: selectedSymbol ?? '',
      quantity: qty,
    );
    await portfolioController.addOrUpdateHolding(holding);
    Get.back();
    Get.showSnackbar(const GetSnackBar(
      duration: Duration(seconds: 2),
      borderRadius: 15,
      messageText: AppText(
        text: "Assets Added",
        color: AppColors.white,
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    ));
  }

  @override
  void dispose() {
    searchctl.dispose();
    qtyctl.dispose();
    super.dispose();
  }
}
