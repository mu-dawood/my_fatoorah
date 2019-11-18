import 'package:flutter/material.dart';

class InitiatePaymentRequest {
  final String currencyIso;
  final String language;
  final double invoiceAmount;

  InitiatePaymentRequest({
    this.currencyIso = "SAR",
    this.language = "AR",
    @required this.invoiceAmount,
  });

  Map<String, dynamic> tojson() {
    return {
      "currencyIso": currencyIso,
      "invoiceAmount": invoiceAmount,
      "language": language,
    };
  }
}
