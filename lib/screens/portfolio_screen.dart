import 'package:crypto_portfolio/controllers/portfolio_controller.dart';
import 'package:crypto_portfolio/extensions/size_helper.dart';
import 'package:crypto_portfolio/theme/app_colors.dart';
import 'package:crypto_portfolio/widgets/add_assets.dart';
import 'package:crypto_portfolio/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class PortfolioScreen extends StatelessWidget {
  final PortfolioController controller = Get.find<PortfolioController>();
  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white.withOpacity(.97),
      body: SafeArea(child: Obx(
        () {
          if (controller.loadingCoins.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchPricesForPortfolio(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  header(),
                  20.h,
                  Row(
                    children: [
                      const AppText(
                        text: "Your Holdings",
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            AddAssetsSheet(),
                            enableDrag: false,
                            isScrollControlled: true,
                            isDismissible: false,
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: AppColors.white,
                              ),
                            )),
                      )
                    ],
                  ),
                  Expanded(child: list())
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  Widget list() {
    return Obx(() {
      final list = controller.portfolio;
      if (list.isEmpty) {
        return const Center(
          child: AppText(
            textAlign: TextAlign.center,
            text: "No holdings yet.\nTap + to add a coin.",
            fontWeight: FontWeight.w600,
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListView.separated(
            separatorBuilder: (context, index) => 10.h,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final holdings = list[index];
              return Dismissible(
                key: Key(holdings.coinId),
                direction: DismissDirection.endToStart,
                onDismissed: (_) async {
                  await controller.removeHolding(holdings.coinId);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text:
                                    "${holdings.coinName} (${holdings.coinSymbol.toUpperCase()})",
                              ),
                            ),
                            10.w,
                            Obx(
                              () {
                                final isTrand = controller
                                    .priceChangeColor(holdings.coinId);
                                if (isTrand != null && isTrand) {
                                  return const Icon(
                                    Icons.trending_up,
                                    color: Colors.green,
                                    size: 20,
                                  );
                                } else if (isTrand != null &&
                                    isTrand == false) {
                                  return const Icon(
                                    Icons.trending_down,
                                    size: 20,
                                    color: Colors.red,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            5.w,
                            Obx(() {
                              final price =
                                  controller.prices[holdings.coinId] ?? 0.0;

                              return AppText(
                                text: formatValue(price),
                              );
                            }),
                          ],
                        ),
                        8.h,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child:
                                    AppText(text: 'Qty: ${holdings.quantity}')),
                            10.w,
                            Obx(() {
                              final price =
                                  controller.prices[holdings.coinId] ?? 0.0;
                              final total = holdings.quantity * price;
                              return AppText(
                                text: formatValue(total),
                                fontWeight: FontWeight.w800,
                              );
                            }),
                          ],
                        ),
                      ],
                    )),
              );
            }),
      );
    });
  }

  String formatValue(double value) {
    if (value < 0.01) {
      return "\$${value.toStringAsPrecision(5)}";
    }
    return currencyFormat.format(value);
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            offset: const Offset(0, 5),
            spreadRadius: 5,
            blurRadius: 30,
          )
        ], color: AppColors.primary, borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: "Portfolio",
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              20.h,
              const AppText(
                text: "Holding Value",
                color: AppColors.white,
                fontSize: 13,
              ),
              5.h,
              Obx(() {
                final total = controller.totalPortfolioValue();
                return AppText(
                    text: currencyFormat.format(total),
                    fontSize: 22,
                    color: AppColors.white,
                    fontWeight: FontWeight.w900);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
