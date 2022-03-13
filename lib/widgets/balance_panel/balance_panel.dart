import 'package:crypto_app/data/crypto_pair_model.dart';
import 'package:crypto_app/data/cryptocurrencies_data.dart';
import 'package:crypto_app/widgets/balance_panel/balance_cryptocurrencies_dialog.dart';
import 'package:crypto_app/widgets/balance_panel/profit_percentage.dart';
import 'package:crypto_app/widgets/crypto_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

void getBalance(List cryptoCharts) async {
  Box portfolioBox = await Hive.openBox('portfolio');
  for (var i = 0; i < portfolioBox.length && i < cryptoCharts.length; i++) {
    CryptoPairModel model = cryptocurrencies
        .firstWhere((e) => e.cryptoName == portfolioBox.keyAt(i));
    models.add(model);
    List chartSpots = cryptoCharts.firstWhere((e) =>
        e['cryptoPairModel'].cryptoName == model.cryptoName)['chartSpots'];
    currentBalance.value +=
        chartSpots.last.y * portfolioBox.values.elementAt(i);
    yesterdayBalance.value +=
        chartSpots[chartSpots.length - 2].y * portfolioBox.values.elementAt(i);
  }
}

RxList<CryptoPairModel> models = List<CryptoPairModel>.empty().obs;
RxDouble currentBalance = 0.0.obs;
RxDouble yesterdayBalance = 0.0.obs;
Center balancePanel(List cryptoCharts, ThemeData themeData) {
  currentBalance.value = 0.0;
  yesterdayBalance.value = 0.0;
  models.value = [];
  getBalance(cryptoCharts);
  return Center(
    child: GestureDetector(
      onTap: () => displayBalanceDialog(cryptoCharts, themeData),
      child: Container(
        decoration: BoxDecoration(
          color: themeData.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 90.w,
        height: 22.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Balance',
                        style: GoogleFonts.lato(
                          color: themeData.primaryColor.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Obx(
                          () => Text(
                            '\$${currentBalance.value.toStringAsFixed(2).replaceFirst('.', ',').replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}',
                            style: GoogleFonts.poppins(
                              color: themeData.primaryColor,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: SizedBox(
                      height: 5.h,
                      width: 25.w,
                      child: Obx(
                        () => ListView.builder(
                          shrinkWrap: true,
                          itemCount: models.length,
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemBuilder: (BuildContext context, int i) {
                            return cryptoIcon(models[i].cryptoIcon, themeData);
                          },
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     cryptoIcon(CryptoFontIcons.ETH, themeData),
                    //     cryptoIcon(CryptoFontIcons.BTC, themeData),
                    //   ],
                    // ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profit',
                        style: GoogleFonts.lato(
                          color: themeData.primaryColor.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.2.h),
                        child: Obx(
                          () => Text(
                            '\$${(currentBalance.value - yesterdayBalance.value).toStringAsFixed(2).replaceFirst('.', ',').replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}',
                            style: GoogleFonts.poppins(
                              color: themeData.primaryColor.withOpacity(0.9),
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => currentBalance.value == 0
                        ? profitPercentageWidget(0)
                        : profitPercentageWidget(
                            ((currentBalance.value - yesterdayBalance.value) /
                                    currentBalance.value) *
                                100),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
