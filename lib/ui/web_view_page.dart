part of my_fatoorah;

class _WebViewPage extends StatefulWidget {
  final String url;
  final String successUrl;
  final String errorUrl;
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
  }) : super(key: key);
  @override
  __WebViewPageState createState() => __WebViewPageState();
}

class __WebViewPageState extends State<_WebViewPage> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  bool loading = true;
  PaymentResponse currentResponse;
  void onUrlChanged(WebViewStateChanged state) {
    currentResponse = _getResponse(state);
    assert(() {
      print("MyFatoorah=> ${state.type} =>${state.url}");
      return true;
    }());
    if (state.type == WebViewState.shouldStart) {
      if (widget.afterPaymentBehaviour ==
          AfterPaymentBehaviour.BeforeCalbacksExecution) {
        if (currentResponse.status != PaymentStatus.None) {
          Navigator.of(context).pop(currentResponse);
          return;
        }
      }
    } else if (state.type == WebViewState.finishLoad) {
      if (widget.afterPaymentBehaviour ==
          AfterPaymentBehaviour.AfterCalbacksExecution) {
        if (currentResponse.status != PaymentStatus.None) {
          Navigator.of(context).pop(currentResponse);
          return;
        }
      }
    }
    if (state.type == WebViewState.shouldStart ||
        state.type == WebViewState.startLoad) {
      setState(() {
        loading = true;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    flutterWebviewPlugin.onStateChanged.listen(onUrlChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pop(currentResponse ?? PaymentResponse(PaymentStatus.None));
        return false;
      },
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    var isSuccess = currentResponse?.status == PaymentStatus.Success;
    var isError = currentResponse?.status == PaymentStatus.Error;
    Widget child;
    if (isError || isSuccess)
      child = isSuccess ? widget.succcessChild : widget.errorChild;
    if (child == null)
      return buildWillPopScope(context);
    else
      return Scaffold(
        appBar: AppBar(),
        body: child,
      );
  }

  Widget buildWillPopScope(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: AnimatedOpacity(
            opacity: loading ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: LinearProgressIndicator(),
          ),
        ),
      ),
      url: widget.url,
      withJavascript: true,
      useWideViewPort: true,
      withZoom: true,
      hidden: true,
      ignoreSSLErrors: true,
    );
  }

  PaymentResponse _getResponse(WebViewStateChanged state) {
    var isSuccess = state.url.contains(widget.successUrl);
    var isError = state.url.contains(widget.errorUrl);
    if (!isError && !isSuccess) return PaymentResponse(PaymentStatus.None);
    PaymentStatus status =
        isSuccess ? PaymentStatus.Success : PaymentStatus.Error;
    Uri uri = Uri.parse(state.url);
    return PaymentResponse(
      status,
      paymentId: uri.queryParameters["paymentId"],
      url: state.url,
    );
  }
}
