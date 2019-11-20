import 'package:flutter/material.dart';
import '../enums/currencyIso.dart';
import '../enums/language.dart';

class InitiatePaymentRequest {
  final CurrencyIso currencyIso;
  final ApiLanguage language;
  final double invoiceAmount;

  InitiatePaymentRequest({
    this.currencyIso = CurrencyIso.SaudiArabia_SAR,
    this.language = ApiLanguage.Arabic,
    @required this.invoiceAmount,
  });

  Map<String, dynamic> tojson() {
    return {
      "currencyIso": currencies[currencyIso],
      "invoiceAmount": invoiceAmount,
      "language": iosLanguages[language],
    };
  }
}
