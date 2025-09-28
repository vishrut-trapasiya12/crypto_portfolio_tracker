import 'package:crypto_portfolio/controllers/add_assets_controller.dart';
import 'package:crypto_portfolio/controllers/portfolio_controller.dart';
import 'package:crypto_portfolio/extensions/size_helper.dart';
import 'package:crypto_portfolio/theme/app_colors.dart';
import 'package:crypto_portfolio/widgets/app_text.dart';
import 'package:crypto_portfolio/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAssetsSheet extends StatelessWidget {
  final PortfolioController ctrl = Get.find<PortfolioController>();
  AddAssetsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AddAssetsController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              height: Get.height * 0.85,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const AppText(
                          text: "Add Assets",
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.black.withOpacity(.07),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        )
                      ],
                    ),
                    10.h,
                    AppTextfield(
                        prefix: const Icon(
                          Icons.search,
                          size: 20,
                        ),
                        onChanged: controller.onSearch,
                        hintText: "Search coin by name",
                        controller: controller.searchctl),
                    10.h,
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => 10.h,
                        itemCount: controller.results.length,
                        itemBuilder: (context, i) {
                          final coin = controller.results[i];
                          final isSelected =
                              coin.id == controller.selectedCoinId;
                          return GestureDetector(
                            onTap: () {
                              controller.selectCoin(controller, coin);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(.8)
                                      : AppColors.black.withOpacity(.02)),
                              padding: const EdgeInsets.all(8),
                              child: AppText(
                                  color: isSelected ? Colors.white : null,
                                  text:
                                      "${coin.name} (${coin.symbol.toUpperCase()})"),
                            ),
                          );
                          // ListTile(
                          //   title: Text(
                          //       '${coin.name} (${coin.symbol.toUpperCase()})'),
                          //   onTap: () {
                          //     controller.selectCoin(controller, coin);
                          //   },
                          //   selected: isSelected,
                          // );
                        },
                      ),
                    ),
                    10.h,
                    AppTextfield(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          controller.update();
                        },
                        hintText: "Quantity",
                        controller: controller.qtyctl),
                    15.h,
                    GestureDetector(
                      onTap: controller.checkEnable() ? controller.save : null,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: controller.checkEnable()
                                ? AppColors.primary
                                : AppColors.black.withOpacity(.2),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                          child: AppText(
                            text: "Save",
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    15.h,
                  ],
                ),
              ),
            ),
          );
        });
  }
}
