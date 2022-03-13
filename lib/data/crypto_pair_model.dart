import 'package:flutter/material.dart';

class CryptoPairModel {
  final String cryptoName;
  final String cryptoBase;
  final String exchangeCurrency;
  final IconData cryptoIcon;

  CryptoPairModel(
    this.cryptoName,
    this.cryptoBase,
    this.exchangeCurrency,
    this.cryptoIcon,
  );
}
