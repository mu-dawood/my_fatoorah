import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../responses/excute_payment_response.dart';

import '../my_fatoorah.dart';
import '../responses/Initiate_payment_response.dart';
import 'payment_view.dart';

class PaymentMethodItem extends StatefulWidget {
  final PaymentMethod method;
  final MyfatoorahRequest request;
  final Widget Function(PaymentMethod method) buildPaymentMethod;

  const PaymentMethodItem({
    Key key,
    @required this.method,
    this.buildPaymentMethod,
    @required this.request,
  }) : super(key: key);
  @override
  _PaymentMethodItemState createState() => _PaymentMethodItemState();
}

class _PaymentMethodItemState extends State<PaymentMethodItem>
    with TickerProviderStateMixin {
  bool loading = false;
  String error;
  Future onPressed() {
    setState(() {
      loading = true;
    });
    var url = '${widget.request.url}/v2/ExecutePayment';
    return http.post(url,
        body: jsonEncode(
            widget.request.excutePaymentRequest(widget.method.paymentMethodId)),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.request.authorizationToken}"
        }).then((response) {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var _response = ExcutePaymentResponse.fromJson(json);
        if (_response.isSuccess) {
          setState(() {
            loading = false;
          });
          if (ModalRoute.of(context).isCurrent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentView(
                  url: _response.data.paymentURL,
                  success: widget.request.successUrl,
                  error: widget.request.errorUrl,
                  forcePop: widget.request.finishAfterCallback == true,
                ),
              ),
            ).then((value) {
              if (value != null) Navigator.of(context).pop(value);
            });
          }
        } else {
          showError(_response.message);
        }
      } else {
        showError(response.body);
      }
    }).catchError(showError);
  }

  void showError(dynamic _error) {
    setState(() {
      error = _error.toString();
      loading = false;
    });
    Future.delayed(Duration(seconds: 5)).then((value) {
      setState(() {
        error = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildItem(),
          if (error != null)
            Container(
              color: Colors.black12,
              padding: EdgeInsets.all(15),
              child: Text(
                error,
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            height: 3,
            child: loading == true ? LinearProgressIndicator() : null,
          ),
        ],
      ),
    );
  }

  Widget buildItem() {
    if (widget.buildPaymentMethod != null) {
      return InkWell(
        onTap: onPressed,
        child: widget.buildPaymentMethod(widget.method),
      );
    }
    return ListTile(
      onTap: onPressed,
      title: Text(widget.method.paymentMethod),
      subtitle: Text("+ ${widget.method.serviceCharge.toStringAsFixed(2)}"),
      trailing: Text(
        widget.method.totalAmount.toStringAsFixed(2),
        style: TextStyle(fontSize: 18),
      ),
      leading: Image.network(widget.method.imageUrl, width: 50),
    );
  }
}
