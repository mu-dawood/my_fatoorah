part of my_fatoorah;

class PaymentMethosDialog extends StatefulWidget {
  final MyfatoorahRequest request;
  final Widget Function(PaymentMethod method) buildPaymentMethod;
  const PaymentMethosDialog({Key key, this.request, this.buildPaymentMethod})
      : super(key: key);
  @override
  _PaymentMethosDialogState createState() => _PaymentMethosDialogState();
}

class _PaymentMethosDialogState extends State<PaymentMethosDialog>
    with TickerProviderStateMixin {
  List<PaymentMethod> methods = [];
  bool loading = true;
  String errorMessage;

  Future loadMethods() {
    var url = '${widget.request.url}/v2/InitiatePayment';
    return http.post(url,
        body: jsonEncode(widget.request.intiatePaymentRequest()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.request.authorizationToken}"
        }).then((response) {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var _response = _InitiatePaymentResponse.fromJson(json);
        setState(() {
          methods = _response.isSuccess ? _response.data.paymentMethods : null;
          errorMessage = _response.isSuccess ? null : _response.message;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          errorMessage = response.body;
        });
      }
    }).catchError((e) {
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    });
  }

  @override
  void initState() {
    loadMethods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 300),
      child: buildChild(),
    );
  }

  Widget buildChild() {
    if (loading == true) {
      return buildLoading();
    } else if (errorMessage != null) {
      return buildError();
    } else {
      return ListView(
        shrinkWrap: true,
        children: ListTile.divideTiles(
          color: Colors.black26,
          tiles: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Text(
                widget.request.invoiceAmount.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...methods.map((e) {
              return _PaymentMethodItem(
                method: e.withLangauge(widget.request.language),
                request: widget.request,
                buildPaymentMethod: widget.buildPaymentMethod,
              );
            }).toList()
          ],
        ).toList(),
      );
    }
  }

  Widget buildError() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.warning),
            iconSize: 50,
            onPressed: () {
              setState(() {
                loading = true;
              });
              loadMethods();
            },
          ),
          SizedBox(height: 15),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  SizedBox buildLoading() {
    return SizedBox(
      height: 100,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
