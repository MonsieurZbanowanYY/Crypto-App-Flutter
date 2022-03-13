import 'package:crypto_app/widgets/actions/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

Future<void> displaySetCryptoDialog(
    Function() forceRefresh, ThemeData themeData) async {
  List<String> cryptoList = ['No Cryptocurrency'];
  RxString selectedValue = 'No Cryptocurrency'.obs;
  Box portfolioBox = await Hive.openBox('portfolio');

  if (portfolioBox.isNotEmpty) {
    cryptoList = [portfolioBox.keys.first];
    selectedValue.value = portfolioBox.keys.first;
  }
  for (var i = 1; i < portfolioBox.length; i++) {
    cryptoList.add(portfolioBox.keyAt(i));
  }

  TextEditingController ammountController = TextEditingController();
  return Get.defaultDialog(
    title: 'Set Portfolio Ammount',
    backgroundColor: themeData.backgroundColor,
    titlePadding: const EdgeInsets.only(top: 8.0),
    radius: 20.0,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: themeData.backgroundColor,
                border: Border.all(
                  color: themeData.primaryColor,
                ),
              ),
              width: 70.w,
              child: DropdownButtonHideUnderline(
                child: Obx(
                  () => DropdownButton<String>(
                    hint: const Text(
                      'No Cryptocurrency',
                    ),
                    menuMaxHeight: 40.h,
                    dropdownColor: themeData.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    style: GoogleFonts.poppins(color: themeData.primaryColor),
                    value: selectedValue.value,
                    items: cryptoList.map(
                      (String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: GoogleFonts.lato(
                              color: themeData.primaryColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (String? valueCh) {
                      selectedValue.value = valueCh.toString();
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Center(
              child: SizedBox(
                width: 70.w,
                child: Obx(
                  () => portfolioBox.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(selectedValue.value)),
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: Text(
                                'Balance: ${portfolioBox.values.elementAt(cryptoList.indexOf(selectedValue.value)).toString().replaceFirst('.', ',').replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  color: themeData.primaryColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            textInputWidget(
                              'Type ammount to set',
                              ammountController,
                              themeData,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (portfolioBox.isEmpty) {
                Get.back();
              } else {
                await removeCrypto(
                    forceRefresh, selectedValue.value, ammountController.text);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: themeData.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Obx(
                  () => selectedValue.value == 'No Cryptocurrency'
                      ? Text(
                          'Close',
                          style: TextStyle(
                            color: themeData.backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          'Set ammount',
                          style: TextStyle(
                            color: themeData.backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Future removeCrypto(
    Function() forceRefresh, String crypto, String value) async {
  if (value.isNotEmpty) {
    Box portfolioBox = await Hive.openBox('portfolio');
    if (double.parse(value) == 0) {
      portfolioBox.delete(crypto);
      forceRefresh();
      Get.back();
    } else {
      portfolioBox.put(
        crypto,
        double.parse(value),
      );
      forceRefresh();
      Get.back();
    }
  }
}
