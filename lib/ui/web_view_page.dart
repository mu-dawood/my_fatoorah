part of my_fatoorah;

class _WebViewPage extends StatefulWidget {
  final Uri uri;
  final String successUrl;
  final String errorUrl;
  final PreferredSizeWidget Function(BuildContext context)? getAppBar;
  final AfterPaymentBehaviour afterPaymentBehaviour;
  final Widget? errorChild;
  final Widget? successChild;
  const _WebViewPage({
    Key? key,
    required this.uri,
    required this.successUrl,
    required this.errorUrl,
    required this.afterPaymentBehaviour,
    this.errorChild,
    this.successChild,
    this.getAppBar,
  }) : super(key: key);
  @override
  __WebViewPageState createState() => __WebViewPageState();
}

class __WebViewPageState extends State<_WebViewPage>
    with TickerProviderStateMixin {
  late InAppWebViewController controller;
  double? progress = 0;
  PaymentResponse response = PaymentResponse(PaymentStatus.None);
  Future<bool> popResult() async {
    if (response.status == PaymentStatus.None && await controller.canGoBack()) {
      controller.goBack();
    } else {
      Navigator.of(context).pop(response);
    }
    return false;
  }

  void setStart(Uri? uri) {
    response = _getResponse(uri, false);
    assert((() {
      print("Start: $uri | Status: ${response.status}");
      return true;
    })());
    if (!response.isNothing &&
        widget.afterPaymentBehaviour ==
            AfterPaymentBehaviour.BeforeCallbackExecution) {
      Navigator.of(context).pop(response);
    } else {
      setState(() {
        progress = 0;
      });
    }
  }

  void setError(Uri? uri, String message) {
    response = _getResponse(uri, false);
    assert((() {
      print("Error: $uri | Status: ${response.status}");
      return true;
    })());
    if (!response.isNothing &&
        widget.afterPaymentBehaviour ==
            AfterPaymentBehaviour.BeforeCallbackExecution) {
      Navigator.of(context).pop(response);
    } else {
      setState(() {
        progress = 0;
      });
    }
  }

  void setStop(Uri? uri) {
    response = _getResponse(uri, false);
    assert((() {
      print("Stop: $uri | Status: ${response.status}");
      return true;
    })());
    if (!response.isNothing &&
        widget.afterPaymentBehaviour ==
            AfterPaymentBehaviour.AfterCallbackExecution) {
      Navigator.of(context).pop(response);
    } else {
      setState(() {
        progress = null;
      });
    }
  }

  void setProgress(int v) {
    setState(() {
      progress = v / 100;
    });
  }

  void onBack() {}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: popResult,
      child: Scaffold(
        appBar:
            widget.getAppBar != null ? widget.getAppBar!(context) : AppBar(),
        body: _stack(context),
      ),
    );
  }

  Widget _stack(BuildContext context) {
    if (widget.successChild == null && widget.errorChild == null) {
      return _build(context);
    }
    Widget? child;
    if (response.isSuccess && widget.successChild != null) {
      child = Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: widget.successChild,
      );
    } else if (response.isError && widget.errorChild != null) {
      child = Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: widget.errorChild,
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        _build(context),
        Positioned.fill(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: child == null ? 0 : 1,
            duration: Duration(milliseconds: 300),
            child: child ?? SizedBox(),
          ),
        )
      ],
    );
  }

  Column _build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          child: SizedBox(
            height: progress == null ? 0 : 5,
            child: LinearProgressIndicator(value: progress ?? 0),
          ),
        ),
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: widget.uri),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
              ),
              ios: IOSInAppWebViewOptions(
                applePayAPIEnabled: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              this.controller = controller;
            },
            onLoadStart: (InAppWebViewController controller, Uri? uri) {
              setStart(uri);
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              var _res = _getResponse(url, false);
              if (!_res.isNothing &&
                  widget.afterPaymentBehaviour ==
                      AfterPaymentBehaviour.BeforeCallbackExecution) {
                Navigator.of(context).pop(_res);
              } else if (!_res.isNothing && response.isNothing) {
                setState(() {
                  response = _res;
                });
              }
            },
            onLoadError: (InAppWebViewController controller, Uri? uri,
                int status, String error) {
              setError(uri, error);
            },
            onLoadHttpError: (InAppWebViewController controller, Uri? uri,
                int status, String error) {
              setError(uri, error);
            },
            onLoadStop: (InAppWebViewController controller, Uri? uri) {
              setStop(uri);
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setProgress(progress);
            },
            onAjaxProgress: (InAppWebViewController controller, request) async {
              var e = request.event;
              if (e != null) {
                var p = (e.loaded! ~/ e.total!) * 100;
                print(p);
                setProgress(p);
              }
              return request.action!;
            },
            onAjaxReadyStateChange:
                (InAppWebViewController controller, request) async {
              print(request.event);

              if (request.readyState == AjaxRequestReadyState.OPENED)
                setStart(request.url);
              else
                setStop(request.url);
              return request.action;
            },
          ),
        ),
      ],
    );
  }

  PaymentResponse _getResponse(Uri? uri, bool error) {
    if (uri == null) return PaymentResponse(PaymentStatus.None);
    var url = uri.toString();
    var isSuccess = url.contains(widget.successUrl);
    var isError = url.contains(widget.errorUrl);
    if (!isError && !isSuccess)
      return PaymentResponse(PaymentStatus.None, url: url);
    PaymentStatus status =
        isSuccess && !error ? PaymentStatus.Success : PaymentStatus.Error;

    return PaymentResponse(
      status,
      paymentId: uri.queryParameters["paymentId"],
      url: url,
    );
  }
}
