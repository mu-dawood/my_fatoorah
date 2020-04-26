part of my_fatoorah;

class PaymentMethosDialog extends StatefulWidget {
  final MyfatoorahRequest request;
  final Widget Function(PaymentMethod method, bool loading, String error)
      buildPaymentMethod;
  final Widget Function(List<Widget> methods) paymentMethodsBuilder;
  const PaymentMethosDialog({
    Key key,
    this.request,
    this.buildPaymentMethod,
    this.paymentMethodsBuilder,
  }) : super(key: key);
  @override
  _PaymentMethosDialogState createState() => _PaymentMethosDialogState();
}

class _PaymentMethosDialogState extends State<PaymentMethosDialog>
    with TickerProviderStateMixin {
  List<PaymentMethod> methods = [];
  bool loading = true;
  String errorMessage;
  String url;
  FlutterWebviewPlugin flutterWebviewPlugin;
  bool webViewClosed = false;

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
    flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onDestroy.listen((event) {
      webViewClosed = true;
    });

    flutterWebviewPlugin.onStateChanged.listen((state) {
      url = state.url;
      print("\u001b[31m${state.type}");
      if (state.type == WebViewState.shouldStart) {
        if (widget.request.afterPaymentBehaviour ==
            AfterPaymentBehaviour.BeforeCalbacksExecution) {
          var response = getResponse();
          if (response.status != PaymentStatus.None) {
            Navigator.of(context).pop(response);
            flutterWebviewPlugin.close();
            return;
          }
        }
        if (!loading) {
          loading = false;
          flutterWebviewPlugin.hide();
        }
      } else if (state.type == WebViewState.finishLoad) {
        if (widget.request.afterPaymentBehaviour ==
            AfterPaymentBehaviour.AfterCalbacksExecution) {
          var response = getResponse();
          if (response.status != PaymentStatus.None) {
            Navigator.of(context).pop(response);
            flutterWebviewPlugin.close();
            return;
          }
        }
        loading = false;
        flutterWebviewPlugin.show();
      } else if (state.type == WebViewState.startLoad && !loading) {
        loading = false;
        flutterWebviewPlugin.hide();
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
        if (response.status != PaymentStatus.None) {
          Navigator.of(context).pop(response);
          if (webViewClosed == false) {
            flutterWebviewPlugin.close();
          }
        } else if (webViewClosed == false) {
          flutterWebviewPlugin.canGoBack().then((value) {
            if (value)
              flutterWebviewPlugin.goBack();
            else {
              flutterWebviewPlugin.close();
              setState(() {
                loading = false;
              });
            }
          });
        } else
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
          method: e.withLangauge(widget.request.language),
          request: widget.request,
          buildPaymentMethod: widget.buildPaymentMethod,
          onLaunch: (String _url) {
            setState(() {
              webViewClosed = false;
              loading = true;
            });
            flutterWebviewPlugin.launch(
              _url,
              withJavascript: true,
              useWideViewPort: true,
              withZoom: true,
              hidden: true,
              ignoreSSLErrors: true,
            );
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
