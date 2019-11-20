import 'package:flutter/material.dart';
import '../enums/currencyIsoIos.dart';
import '../enums/language.dart';

class InitiatePaymentRequest {
  final String currencyIsoAndroid;
  final CurrencyIsoIos currencyIsoIos;
  final ApiLanguage language;
  final double invoiceAmount;

  InitiatePaymentRequest({
    this.currencyIsoAndroid = "SAR",
    this.currencyIsoIos = CurrencyIsoIos.SaudiArabia_SAR,
    this.language = ApiLanguage.Arabic,
    @required this.invoiceAmount,
  });

  Map<String, dynamic> tojson() {
    return {
      "currencyIsoAndroid": currencyIsoAndroid,
      "currencyIsoIos": iosCurrencies[currencyIsoIos],
      "invoiceAmount": invoiceAmount,
      "language": iosLanguages[language],
    };
  }
}
