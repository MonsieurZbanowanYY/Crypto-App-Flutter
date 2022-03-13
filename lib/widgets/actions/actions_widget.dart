import 'package:crypto_app/widgets/actions/action_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unicons/unicons.dart';

Padding actionsWidget(Function() forceRefresh, ThemeData themeData) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.5.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        actionWidget(UniconsLine.download_alt, 'Add', forceRefresh, themeData),
        actionWidget(UniconsLine.money_bill, 'Set', forceRefresh, themeData),
        actionWidget(UniconsLine.upload_alt, 'Remove', forceRefresh, themeData),
      ],
    ),
  );
}
