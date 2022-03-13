import 'package:crypto_app/data/cryptocurrencies_data.dart';
import 'package:crypto_app/widgets/actions/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

Future<void> displayAddCryptoDialog(Function() forceRefresh,
    String selectedValueDefault, ThemeData themeData) async {
  List<String> cryptoList = [];
  for (var i = 0; i < cryptocurrencies.length; i++) {
    cryptoList.add(cryptocurrencies[i].cryptoName);
  }
  RxString selectedValue = selectedValueDefault.obs;
  TextEditingController ammountController = TextEditingController();
  return Get.defaultDialog(
    title: 'Add Cryptocurrency',
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
                      'Select Cryptocurrency',
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
                child: textInputWidget(
                  'Type ammount',
                  ammountController,
                  themeData,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              addCrypto(
                  forceRefresh, selectedValue.value, ammountController.text);
              forceRefresh();
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: themeData.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Add Cryptocurrency',
                  style: TextStyle(
                    color: themeData.backgroundColor,
                    fontWeight: FontWeight.bold,
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

Future addCrypto(Function() forceRefresh, String crypto, String value) async {
  Box portfolioBox = await Hive.openBox('portfolio');

  if (portfolioBox.get(crypto) == null) {
    portfolioBox.put(
      crypto,
      double.parse(value),
    );
  } else {
    double storedValue = portfolioBox.get(crypto);
    portfolioBox.put(
      crypto,
      storedValue + double.parse(value),
    );
  }
}
