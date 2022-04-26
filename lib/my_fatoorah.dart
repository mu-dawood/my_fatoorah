library my_fatoorah;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

part './enums/currency_iso.dart';
part './enums/language.dart';
part './enums/other.dart';
part './request/consignee.dart';
part './request/customer_address.dart';
part './request/direct_payment.dart';
part './request/invoice_item.dart';
part './request/my_fatoorah_request.dart';
part './request/recurring_model.dart';
part './request/supplier.dart';
part './response/Initiate_payment_response.dart';
part './response/base_response.dart';
part './response/direct_payment_response.dart';
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
    /// the default is `ListView`
    Widget Function(List<PaymentMethod> methods, LoadingState state,
            Future Function(PaymentMethod method) submit)?
        builder,
    required MyfatoorahRequest request,
    //Will be shown after failed payment `afterPaymentBehaviour must be none`
    Widget? errorChild,
    //Will be shown after success payment `afterPaymentBehaviour must be none`
    Widget? successChild,

    /// this will controls what happen after payment done
    ///
    /// [AfterPaymentBehaviour.None] the default value , nothing will happen
    ///
    /// [AfterPaymentBehaviour.AfterCallbackExecution] will pop after payment done and error or success callbacks finish
    ///
    /// [AfterPaymentBehaviour.BeforeCallbackExecution] will pop after payment done and before error or success callbacks start
    AfterPaymentBehaviour afterPaymentBehaviour = AfterPaymentBehaviour.None,
    //Note if you override leading please use mayBePop instead of pop
    PreferredSizeWidget Function(BuildContext context)? buildAppBar,

    /// Filter payment methods after fetching it
    List<PaymentMethod> Function(List<PaymentMethod> methods)?
        filterPaymentMethods,
    DirectPaymentCallBack? directPayment,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: _PaymentMethodsBuilder(
            errorChild: errorChild,
            directPayment: directPayment,
            getAppBar: buildAppBar,
            onResult: null,
            successChild: successChild,
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
  /// the default is `ListView`
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
  final Widget? successChild;
  final Function(PaymentResponse res)? onResult;

  /// this will controls what happen after payment done
  ///
  /// [AfterPaymentBehaviour.None] the default value , nothing will happen
  ///
  /// [AfterPaymentBehaviour.AfterCallbackExecution] will pop after payment done and error or success callbacks finish
  ///
  /// [AfterPaymentBehaviour.BeforeCallbackExecution] will pop after payment done and before error or success callbacks start
  final AfterPaymentBehaviour afterPaymentBehaviour;

  /// Note if you override leading please use mayBePop instead of pop
  final PreferredSizeWidget Function(BuildContext context)? buildAppBar;
  final DirectPaymentCallBack? directPayment;
  const MyFatoorah({
    Key? key,
    this.builder,
    required this.request,
    this.showServiceCharge = false,
    this.errorChild,
    this.successChild,
    this.afterPaymentBehaviour = AfterPaymentBehaviour.None,
    this.buildAppBar,
    this.filterPaymentMethods,
    this.onResult,
    this.directPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PaymentMethodsBuilder(
      request: request,
      errorChild: errorChild,
      getAppBar: buildAppBar,
      filterPaymentMethods: filterPaymentMethods,
      afterPaymentBehaviour: afterPaymentBehaviour,
      successChild: successChild,
      onResult: onResult ?? (v) {},
      showServiceCharge: showServiceCharge,
      directPayment: directPayment,
      builder: builder,
    );
  }
}
