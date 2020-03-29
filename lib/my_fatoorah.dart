library my_fatoorah;

import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

part './enums/currency_iso.dart';
part './enums/language.dart';
part './enums/other.dart';
part './request/customer_address.dart';
part './request/invoice_item.dart';
part './request/my_fatoorah_request.dart';
part './response/Initiate_payment_response.dart';
part './response/base_response.dart';
part './response/excute_payment_response.dart';
part './response/payment_method.dart';
part './response/payment_response.dart';
part './ui/payment_method.dart';
part './ui/payment_methods_dialog.dart';
part './ui/payment_view.dart';

class MyFatoorah {
  static Future<PaymentResponse> startPayment({
    @required BuildContext context,

    /// user this to customize the single payment method
    /// thev default is `ListTile`
    Widget Function(PaymentMethod method, bool loading, String error)
        buildPaymentMethod,

    /// user this to customize the wrapper of paymentmethods
    /// thev default is `ListView`
    Widget Function(List<Widget> methods) methodsBuilder,
    @required MyfatoorahRequest request,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: PaymentMethosDialog(
            request: request,
            buildPaymentMethod: buildPaymentMethod,
            paymentMethodsBuilder: methodsBuilder,
          ),
        );
      },
    ).then((res) {
      if (res is PaymentResponse)
        return res;
      else
        throw Exception("The payment is not completed");
    });
  }
}
