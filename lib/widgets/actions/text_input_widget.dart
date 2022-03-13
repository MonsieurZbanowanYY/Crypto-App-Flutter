import 'package:crypto_app/widgets/actions/text_form_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

TextFormField textInputWidget(
  String hintText,
  TextEditingController ammountController,
  ThemeData themeData,
) {
  return TextFormField(
    textInputAction: TextInputAction.next,
    maxLength: 30,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
    ],
    controller: ammountController,
    style: TextStyle(
      color: themeData.primaryColor,
      fontSize: 12.sp,
      overflow: TextOverflow.ellipsis,
    ),
    cursorColor: themeData.primaryColor,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
      hintText: hintText,
      border: textFormBorder(themeData),
      focusedBorder: textFormBorder(themeData),
      enabledBorder: textFormBorder(themeData),
      disabledBorder: textFormBorder(themeData),
      errorMaxLines: 1,
    ),
  );
}
