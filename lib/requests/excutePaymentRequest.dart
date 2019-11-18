import 'package:flutter/material.dart';

class ExcutePaymentRequest {
  final String currencyIsoDisplay;
  final String language;
  final double invoiceAmount;
  final String callBackUrl;
  final String errorUrl;
  final int paymentMethod;
  ExcutePaymentRequest({
    @required this.callBackUrl,
    @required this.errorUrl,
    @required this.paymentMethod,
    this.currencyIsoDisplay = "ريال",
    this.language = "AR",
    @required this.invoiceAmount,
  });

  Map<String, dynamic> tojson() {
    return {
      "currencyIso": currencyIsoDisplay,
      "invoiceAmount": invoiceAmount,
      "language": language,
      "callBackUrl": callBackUrl,
      "errorUrl": errorUrl,
      "paymentMethod": paymentMethod,
    };
  }
}
