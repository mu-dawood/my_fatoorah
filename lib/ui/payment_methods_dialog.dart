part of my_fatoorah;

class _PaymentMethodsBuilder extends StatefulWidget {
  final MyfatoorahRequest request;
  final Function(PaymentResponse res) onResult;
  final bool showServiceCharge;
  final Widget Function(PaymentMethod method, bool loading, String error)
      buildPaymentMethod;
  final Widget Function(List<Widget> methods) paymentMethodsBuilder;
  const _PaymentMethodsBuilder({
    Key key,
    @required this.request,
    @required this.buildPaymentMethod,
    @required this.paymentMethodsBuilder,
    this.onResult,
    @required this.showServiceCharge,
  }) : super(key: key);
  @override
  _PaymentMethodsBuilderState createState() => _PaymentMethodsBuilderState();
}

class _PaymentMethodsBuilderState extends State<_PaymentMethodsBuilder>
    with TickerProviderStateMixin {
  List<PaymentMethod> methods = [];
  bool loading = true;
  String errorMessage;
  String url;
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  Future loadMethods() {
    var url = widget.request.initiatePaymentUrl ??
        '${widget.request.url}/v2/InitiatePayment';

    return http.post(url,
        body: jsonEncode(widget.request.intiatePaymentRequest()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.request.authorizationToken}",
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
      print(e);
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    });
  }

  PaymentResponse getResponse() {
    if (url == null) return PaymentResponse(PaymentStatus.None);
    Uri uri = Uri.parse(url);
    var isSuccess = url.contains(widget.request.successUrl);
    var isError = url.contains(widget.request.errorUrl);
    if (!isError && !isSuccess) return PaymentResponse(PaymentStatus.None);
    PaymentStatus status =
        isSuccess ? PaymentStatus.Success : PaymentStatus.Error;

    return PaymentResponse(status, uri.queryParameters["paymentId"]);
  }

  @override
  void initState() {
    loadMethods();

    flutterWebviewPlugin.onStateChanged.listen((state) {
      url = state.url;
      print("${state.type} => $url");
      if (state.type == WebViewState.shouldStart) {
        if (widget.request.afterPaymentBehaviour ==
            AfterPaymentBehaviour.BeforeCalbacksExecution) {
          var response = getResponse();
          if (response.status != PaymentStatus.None) {
            Navigator.of(context).pop();
            return;
          }
        }
      } else if (state.type == WebViewState.finishLoad) {
        if (widget.request.afterPaymentBehaviour ==
            AfterPaymentBehaviour.AfterCalbacksExecution) {
          var response = getResponse();
          if (response.status != PaymentStatus.None) {
            Navigator.of(context).pop();
            return;
          }
        }
      }
    });
    super.initState();
  }

  @override
  dispose() {
    flutterWebviewPlugin.close();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var response = getResponse();
        if (widget.onResult != null) {
          widget.onResult(response);
          return true;
        }
        Navigator.of(context).pop(response);

        return false;
      },
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 300),
        child: buildChild(),
      ),
    );
  }

  Widget buildChild() {
    if (loading == true) {
      return buildLoading();
    } else if (errorMessage != null) {
      return buildError();
    } else {
      List<Widget> childs = methods.map((e) {
        return _PaymentMethodItem(
          showServiceCharge: widget.showServiceCharge,
          method: e.withLangauge(widget.request.language),
          request: widget.request,
          buildPaymentMethod: widget.buildPaymentMethod,
          onLaunch: (String _url) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _WebViewPage(url: _url),
              ),
            ).then((value) {
              var response = getResponse();
              if (response.status != null &&
                  response.status != PaymentStatus.None) {
                if (widget.onResult != null)
                  widget.onResult(response);
                else
                  Navigator.of(context).pop(response);
              }
            });
          },
        );
      }).toList();
      if (widget.paymentMethodsBuilder != null)
        return widget.paymentMethodsBuilder(childs);
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
            ...childs,
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
