import 'package:crypto_app/data/crypto_pair_model.dart';
import 'package:crypto_app/data/cryptocurrencies_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

Future<void> displayBalanceDialog(
    List cryptoCharts, ThemeData themeData) async {
  Box portfolioBox = await Hive.openBox('portfolio');

  return Get.defaultDialog(
    title: 'Your Cryptocurrencies\n(24h change)',
    backgroundColor: themeData.backgroundColor,
    titlePadding: EdgeInsets.only(top: 2.h),
    radius: 20.0,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SizedBox(
          width: 90.w,
          height:
              portfolioBox.isEmpty || cryptoCharts.length < portfolioBox.length
                  ? 20.h
                  : portfolioBox.length * 16.h < 45.h
                      ? portfolioBox.length * 16.h
                      : 45.h,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: portfolioBox.isEmpty ||
                    cryptoCharts.length < portfolioBox.length
                ? 1
                : portfolioBox.length,
            itemBuilder: (BuildContext context, int i) {
              if (portfolioBox.isEmpty ||
                  cryptoCharts.length < portfolioBox.length) {
                return Align(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      "Not found!\nCheck your internet connection\nor\nAdd crypto to your portfolio",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                CryptoPairModel model = cryptocurrencies
                    .firstWhere((e) => e.cryptoName == portfolioBox.keyAt(i));
                List chart = cryptoCharts.firstWhere((e) =>
                    e['cryptoPairModel'].cryptoName ==
                    model.cryptoName)['chartSpots'];
                double price = chart.last.y;
                double yesterdayPrice = chart[chart.length - 2].y;
                double profitPercent = ((price - yesterdayPrice) / price) * 100;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 0.5.w),
                          child: Icon(
                            model.cryptoIcon,
                            size: 17.sp,
                          ),
                        ),
                        Text(
                          model.cryptoName,
                          style: GoogleFonts.lato(
                            color: themeData.primaryColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${portfolioBox.getAt(i).toString().replaceFirst('.', ',').replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')} ${model.cryptoBase}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        letterSpacing: 1,
                        color: themeData.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '\$${(portfolioBox.getAt(i) * price).toStringAsFixed(2).replaceFirst('.', ',').replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        letterSpacing: 1,
                        color: themeData.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      price - yesterdayPrice > 0
                          ? '+' +
                              ((price - yesterdayPrice) * portfolioBox.getAt(i))
                                  .toStringAsFixed(2)
                                  .replaceFirst('.', ',')
                                  .replaceAll(
                                      RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')
                          : ((price - yesterdayPrice) * portfolioBox.getAt(i))
                              .toStringAsFixed(2)
                              .replaceFirst('.', ',')
                              .replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        letterSpacing: 1,
                        color: price - yesterdayPrice > 0
                            ? Colors.green[600]
                            : Colors.red[600],
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      profitPercent > 0
                          ? '+' +
                              (profitPercent * portfolioBox.getAt(i))
                                  .toStringAsFixed(2)
                                  .replaceFirst('.', ',')
                                  .replaceAll(
                                      RegExp(r'\B(?=(\d{3})+(?!\d))'), '.') +
                              '%'
                          : (profitPercent * portfolioBox.getAt(i))
                                  .toStringAsFixed(2)
                                  .replaceFirst('.', ',')
                                  .replaceAll(
                                      RegExp(r'\B(?=(\d{3})+(?!\d))'), '.') +
                              '%',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        letterSpacing: 1,
                        color: profitPercent > 0
                            ? Colors.green[600]
                            : Colors.red[600],
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                    Divider(
                      color: themeData.primaryColor,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    ),
  );
}

OutlineInputBorder textFormBorder(themeData) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(
      color: themeData.primaryColor,
    ),
  );
}
