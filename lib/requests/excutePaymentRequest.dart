import 'package:flutter/material.dart';
import '../enums/currencyIsoIos.dart';
import '../enums/language.dart';

class ExcutePaymentRequest {
  final String currencyIsoDisplay;
  final ApiLanguage language;
  final double invoiceAmount;
  final String callBackUrl;
  final String errorUrl;
  final int paymentMethod;
  ExcutePaymentRequest({
    @required this.callBackUrl,
    @required this.errorUrl,
    @required this.paymentMethod,
    this.currencyIsoDisplay = "ريال",
    this.language = ApiLanguage.Arabic,
    @required this.invoiceAmount,
  });

  Map<String, dynamic> tojson() {
    return {
      "currencyIso": currencyIsoDisplay,
      "invoiceAmount": invoiceAmount,
      "language": iosLanguages[language],
      "callBackUrl": callBackUrl,
      "errorUrl": errorUrl,
      "paymentMethod": paymentMethod,
    };
  }
}
