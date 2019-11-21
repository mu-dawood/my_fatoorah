import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:my_fatoorah/requests/excutePaymentRequest.dart';
import 'package:my_fatoorah/responses/paymentMethod.dart';

import 'requests/configRequest.dart';
import 'requests/initiatePaymentRequest.dart';
import 'responses/paymentResult.dart';

class MyFatoorah {
  static const MethodChannel _channel = const MethodChannel('my_fatoorah');

  static Future config(ConfigRequest request) {
    return _channel.invokeMethod('config', request.tojson());
  }

  static Future<List<PaymentMethod>> initiatePayment(
      InitiatePaymentRequest request) {
    return _channel
        .invokeMethod('initiatePayment', request.tojson())
        .then((data) {
      print(data);
      var json = jsonDecode(data);
      List list = json["PaymentMethods"];
      return list.map((item) => PaymentMethod.fromJson(item)).toList();
    });
  }

  static Future<PaymentResult> executePayment(ExcutePaymentRequest request) {
    return _channel
        .invokeMethod('executePayment', request.tojson())
        .then((data) {
      var json = jsonDecode(data);
      return PaymentResult.fromJson(json);
    }).catchError((e) {
      print(e);
    });
  }
}
