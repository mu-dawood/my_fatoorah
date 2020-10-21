part of my_fatoorah;

class _WebViewPage extends StatefulWidget {
  final String url;
  final String successUrl;
  final String errorUrl;
  final PreferredSizeWidget Function(VoidCallback back) getAppBar;
  final AfterPaymentBehaviour afterPaymentBehaviour;
  final Widget errorChild;
  final Widget succcessChild;
  const _WebViewPage({
    Key key,
    @required this.url,
    @required this.successUrl,
    @required this.errorUrl,
    @required this.afterPaymentBehaviour,
    @required this.errorChild,
    @required this.succcessChild,
    @required this.getAppBar,
  }) : super(key: key);
  @override
  __WebViewPageState createState() => __WebViewPageState();
}

class __WebViewPageState extends State<_WebViewPage>
    with TickerProviderStateMixin {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  bool loading = true;
  PaymentResponse currentResponse;
  WebViewState state;
  WebViewHttpError httpError;
  void onUrlChanged(WebViewStateChanged _state) {
    state = _state.type;
    currentResponse = _getResponse(_state);

    assert(() {
      print("MyFatoorah=> $state =>${_state.url}");
      return true;
    }());
    if (state == WebViewState.shouldStart) {
      if (widget.afterPaymentBehaviour ==
          AfterPaymentBehaviour.BeforeCalbacksExecution) {
        if (currentResponse.status != PaymentStatus.None) {
          Navigator.of(context).pop(currentResponse);
          return;
        }
      }
    } else if (state == WebViewState.finishLoad) {
      if (widget.afterPaymentBehaviour ==
          AfterPaymentBehaviour.AfterCalbacksExecution) {
        if (currentResponse.status != PaymentStatus.None) {
          Navigator.of(context).pop(currentResponse);
          return;
        }
      }
    }
    if (state == WebViewState.shouldStart || state == WebViewState.startLoad) {
      setState(() {
        loading = true;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void onHttpError(WebViewHttpError event) {
    httpError = event;
    assert(() {
      print("MyFatoorah=> ${event.code} =>${event.url}");
      return true;
    }());
  }

  @override
  void initState() {
    flutterWebviewPlugin.onHttpError.listen(onHttpError);
    flutterWebviewPlugin.onStateChanged.listen(onUrlChanged);
    super.initState();
  }

  void popResult() {
    Navigator.of(context)
        .pop(currentResponse ?? PaymentResponse(PaymentStatus.None));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    var isSuccess = currentResponse?.status == PaymentStatus.Success;
    var isError = currentResponse?.status == PaymentStatus.Error;
    var canShowResult = state == WebViewState.finishLoad;
    Widget child;
    if (canShowResult && (isError || isSuccess))
      child = isSuccess ? widget.succcessChild : widget.errorChild;
    var appBar = widget.getAppBar == null
        ? AppBar(
            leading: BackButton(onPressed: popResult),
          )
        : widget.getAppBar(popResult);
    if (child == null)
      return buildWillPopScope(context, appBar);
    else
      return Scaffold(
        appBar: appBar,
        body: child,
      );
  }

  Widget buildWillPopScope(BuildContext context, PreferredSizeWidget appBar) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: WebviewScaffold(
            appBar: appBar,
            url: widget.url,
            withJavascript: true,
            useWideViewPort: true,
            withZoom: true,
            hidden: loading,
            ignoreSSLErrors: true,
            bottomNavigationBar: AnimatedSize(
              duration: Duration(milliseconds: 300),
              vsync: this,
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  PaymentResponse _getResponse(WebViewStateChanged _state) {
    var isSuccess = _state.url.contains(widget.successUrl);
    var isError = _state.url.contains(widget.errorUrl);
    if (!isError && !isSuccess) return PaymentResponse(PaymentStatus.None);
    PaymentStatus status =
        isSuccess ? PaymentStatus.Success : PaymentStatus.Error;
    if (isSuccess &&
        (state == WebViewState.abortLoad || httpError?.url == _state.url)) {
      status = PaymentStatus.Error;
    }
    Uri uri = Uri.parse(_state.url);

    return PaymentResponse(
      status,
      paymentId: uri.queryParameters["paymentId"],
      url: _state.url,
    );
  }
}
