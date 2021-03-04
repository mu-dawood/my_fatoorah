library my_fatoorah;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
    required BuildContext context,
    //If this is true service charge will be shown in subtitle defaults to false
    bool showServiceCharge = false,

    /// user this to build your own ui and then at the end call submit
    /// submit method is future so you can wait it
    /// thev default is `ListView`
    Widget Function(List<PaymentMethod> methods, LoadingState state,
            Future Function(PaymentMethod method) submit)?
        builder,
    required MyfatoorahRequest request,
    //Will be shown after failed payment `afterPaymentBehaviour must be none`
    Widget? errorChild,
    //Will be shown after success payment `afterPaymentBehaviour must be none`
    Widget? succcessChild,

    /// this will controles what happen after payment done
    ///
    /// `AfterPaymentBehaviour.None` the default value , nothing will happen
    ///
    /// `AfterPaymentBehaviour.AfterCalbacksExecution` will pop after payment done and error or success callbacks finish
    ///
    /// `AfterPaymentBehaviour.BeforeCalbacksExecution` will pop after payment done and before error or success callbacks start
    AfterPaymentBehaviour afterPaymentBehaviour = AfterPaymentBehaviour.None,
    //Note if you ovveride leading please use maybepop instead of pop
    PreferredSizeWidget Function(BuildContext context)? buildAppBar,

    /// Filter payment methods after fetching it
    final List<PaymentMethod> Function(List<PaymentMethod> methods)?
        filterPaymentMethods,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: _PaymentMethodsBuilder(
            errorChild: errorChild,
            getAppBar: buildAppBar,
            onResult: null,
            succcessChild: succcessChild,
            filterPaymentMethods: filterPaymentMethods,
            afterPaymentBehaviour: afterPaymentBehaviour,
            request: request,
            showServiceCharge: showServiceCharge,
            builder: builder,
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

  /// user this to build your own ui and then at the end call submit
  /// submit method is future so you can wait it
  /// thev default is `ListView`
  final Widget Function(List<PaymentMethod> methods, LoadingState state,
      Future<PaymentResponse> Function(PaymentMethod method) submit)? builder;

  /// Filter payment methods after fetching it
  final List<PaymentMethod> Function(List<PaymentMethod> methods)?
      filterPaymentMethods;

  final MyfatoorahRequest request;
  //If this is true service charge will be shown in subtitle
  final bool showServiceCharge;
  //Will be shown after failed payment `afterPaymentBehaviour must be none`
  final Widget? errorChild;
  //Will be shown after error payment `afterPaymentBehaviour must be none`
  final Widget? succcessChild;
  final Function(PaymentResponse res)? onResult;

  /// this will controles what happen after payment done
  ///
  /// `AfterPaymentBehaviour.None` the default value , nothing will happen
  ///
  /// `AfterPaymentBehaviour.AfterCalbacksExecution` will pop after payment done and error or success callbacks finish
  ///
  /// `AfterPaymentBehaviour.BeforeCalbacksExecution` will pop after payment done and before error or success callbacks start
  final AfterPaymentBehaviour afterPaymentBehaviour;
  //Note if you ovveride leading please use maybepop instead of pop
  final PreferredSizeWidget Function(BuildContext context)? buildAppBar;
  const MyFatoorah({
    Key? key,
    this.builder,
    required this.request,
    this.showServiceCharge = false,
    this.errorChild,
    this.succcessChild,
    this.afterPaymentBehaviour = AfterPaymentBehaviour.None,
    this.buildAppBar,
    this.filterPaymentMethods,
    this.onResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PaymentMethodsBuilder(
      request: request,
      errorChild: errorChild,
      getAppBar: buildAppBar,
      filterPaymentMethods: filterPaymentMethods,
      afterPaymentBehaviour: afterPaymentBehaviour,
      succcessChild: succcessChild,
      onResult: onResult ?? (v) {},
      showServiceCharge: showServiceCharge,
      builder: builder,
    );
  }
}
