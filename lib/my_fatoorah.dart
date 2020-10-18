library my_fatoorah;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

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
part './ui/web_view_page.dart';

class MyFatoorah extends StatelessWidget {
  static Future<PaymentResponse> startPayment({
    @required BuildContext context,
    //If this is true service charge will be shown in subtitle defaults to false
    bool showServiceCharge = false,

    /// user this to customize the single payment method
    /// thev default is `ListTile`
    Widget Function(PaymentMethod method, bool loading, String error)
        buildPaymentMethod,

    /// user this to customize the wrapper of paymentmethods
    /// thev default is `ListView`
    Widget Function(List<Widget> methods) builder,
    @required MyfatoorahRequest request,
    //Will be shown after failed payment `afterPaymentBehaviour must be none`
    Widget errorChild,
    //Will be shown after success payment `afterPaymentBehaviour must be none`
    Widget succcessChild,

    /// this will controles what happen after payment done
    ///
    /// `AfterPaymentBehaviour.None` the default value , nothing will happen
    ///
    /// `AfterPaymentBehaviour.AfterCalbacksExecution` will pop after payment done and error or success callbacks finish
    ///
    /// `AfterPaymentBehaviour.BeforeCalbacksExecution` will pop after payment done and before error or success callbacks start
    AfterPaymentBehaviour afterPaymentBehaviour,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: _PaymentMethodsBuilder(
            errorChild: errorChild,
            succcessChild: succcessChild,
            afterPaymentBehaviour:
                afterPaymentBehaviour ?? AfterPaymentBehaviour.None,
            request: request,
            buildPaymentMethod: buildPaymentMethod,
            showServiceCharge: showServiceCharge,
            paymentMethodsBuilder: builder,
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

  final Widget Function(PaymentMethod method, bool loading, String error)
      buildPaymentMethod;

  /// user this to customize the wrapper of paymentmethods
  /// thev default is `ListView`
  final Widget Function(List<Widget> methods) builder;

  final MyfatoorahRequest request;
  final Function(PaymentResponse res) onResult;
  //If this is true service charge will be shown in subtitle
  final bool showServiceCharge;
  //Will be shown after failed payment `afterPaymentBehaviour must be none`
  final Widget errorChild;
  //Will be shown after error payment `afterPaymentBehaviour must be none`
  final Widget succcessChild;

  /// this will controles what happen after payment done
  ///
  /// `AfterPaymentBehaviour.None` the default value , nothing will happen
  ///
  /// `AfterPaymentBehaviour.AfterCalbacksExecution` will pop after payment done and error or success callbacks finish
  ///
  /// `AfterPaymentBehaviour.BeforeCalbacksExecution` will pop after payment done and before error or success callbacks start
  final AfterPaymentBehaviour afterPaymentBehaviour;
  const MyFatoorah({
    Key key,
    this.buildPaymentMethod,
    this.builder,
    @required this.request,
    @required this.onResult,
    this.showServiceCharge = false,
    this.errorChild,
    this.succcessChild,
    this.afterPaymentBehaviour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PaymentMethodsBuilder(
      request: request,
      errorChild: errorChild,
      afterPaymentBehaviour:
          afterPaymentBehaviour ?? AfterPaymentBehaviour.None,
      succcessChild: succcessChild,
      onResult: onResult,
      showServiceCharge: showServiceCharge,
      buildPaymentMethod: buildPaymentMethod,
      paymentMethodsBuilder: builder,
    );
  }
}
