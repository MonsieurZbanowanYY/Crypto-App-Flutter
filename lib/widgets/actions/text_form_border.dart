import 'package:flutter/material.dart';

OutlineInputBorder textFormBorder(themeData) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(
      color: themeData.primaryColor,
    ),
  );
}
