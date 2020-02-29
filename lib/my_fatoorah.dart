library my_fatoorah;

import 'package:my_fatoorah/requests/my_fatoorah_request.dart';
import 'package:flutter/material.dart';
import 'responses/Initiate_payment_response.dart';
import 'ui/payment_methods_dialog.dart';

export './requests/my_fatoorah_request.dart';
export './responses/Initiate_payment_response.dart';
export './enums/currencyIso.dart';
export './responses/Initiate_payment_response.dart';
export './enums/language.dart';

class MyFatoorah {
  static Future<bool> startPayment({
    @required BuildContext context,
    Widget Function(PaymentMethod method) buildPaymentMethod,
    @required MyfatoorahRequest request,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: PaymentMethosDialog(
            request: request,
          ),
        );
      },
    );
  }
}
