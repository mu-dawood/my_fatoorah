part of my_fatoorah;

class _PaymentMethodItem extends StatefulWidget {
  final PaymentMethod method;
  final MyfatoorahRequest request;
  final Function(String url) onLaunch;
  final bool showServiceCharge;

  const _PaymentMethodItem({
    Key? key,
    required this.method,
    required this.request,
    required this.onLaunch,
    required this.showServiceCharge,
  }) : super(key: key);
  @override
  __PaymentMethodItemState createState() => __PaymentMethodItemState();

  static Future<_ExcutePaymentResponse> loadExcustion(
      MyfatoorahRequest request, PaymentMethod method) {
    var url = request.executePaymentUrl ?? '${request.url}/v2/ExecutePayment';
    return http.post(Uri.parse(url),
        body: jsonEncode(request.excutePaymentRequest(method.paymentMethodId!)),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${request.token.replaceAll("bearer ", "")}"
        }).then((response) {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var _response = _ExcutePaymentResponse.fromJson(json);
        if (_response.isSuccess) {
          return _response;
        } else {
          throw Exception(_response.message);
        }
      } else {
        throw Exception(response.body);
      }
    });
  }
}

class __PaymentMethodItemState extends State<_PaymentMethodItem>
    with TickerProviderStateMixin {
  bool loading = false;
  String? error;

  Future onPressed() {
    setState(() {
      loading = true;
    });
    return _PaymentMethodItem.loadExcustion(widget.request, widget.method)
        .then((response) {
      setState(() {
        loading = false;
      });
      widget.onLaunch(response.data!.paymentURL);
    }).catchError(showError);
  }

  FutureOr<Null> showError(dynamic _error) {
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
                error ?? "",
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
    return ListTile(
      onTap: onPressed,
      title: Text(widget.method.paymentMethod),
      subtitle: widget.showServiceCharge == true
          ? Text("+ ${widget.method.serviceCharge.toStringAsFixed(2)}")
          : null,
      trailing: widget.showServiceCharge == true
          ? Text(
              widget.method.totalAmount.toStringAsFixed(2),
              style: TextStyle(fontSize: 18),
            )
          : null,
      leading: Image.network(widget.method.imageUrl, width: 50),
    );
  }
}
