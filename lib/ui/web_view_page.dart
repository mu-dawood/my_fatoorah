part of my_fatoorah;

// class MyChromeSafariBrowser extends ChromeSafariBrowser {
//   @override
//   void onOpened() {
//     print("ChromeSafari browser opened");
//   }

//   @override
//   void onCompletedInitialLoad() {
//     print("ChromeSafari browser initial load completed");
//   }

//   @override
//   void onClosed() {
//     print("ChromeSafari browser closed");
//   }

//   static Future openB({
//     required Uri uri,
//     required String successUrl,
//     required String errorUrl,
//     PreferredSizeWidget Function(BuildContext contex)? getAppBar,
//     required AfterPaymentBehaviour afterPaymentBehaviour,
//     Widget? errorChild,
//     Widget? succcessChild,
//   }) async {
//     var browser = MyChromeSafariBrowser();
//     await browser.open(
//       url: uri,
//       options: ChromeSafariBrowserClassOptions(
//         android: AndroidChromeCustomTabsOptions(
//             addDefaultShareMenuItem: false, keepAliveEnabled: true),
//         ios: IOSSafariOptions(
//           dismissButtonStyle: IOSSafariDismissButtonStyle.CLOSE,
//           presentationStyle: IOSUIModalPresentationStyle.FULL_SCREEN,
//         ),
//       ),
//     );
//   }
// }

class _WebViewPage extends StatefulWidget {
  final Uri uri;
  final String successUrl;
  final String errorUrl;
  final PreferredSizeWidget Function(BuildContext contex)? getAppBar;
  final AfterPaymentBehaviour afterPaymentBehaviour;
  final Widget? errorChild;
  final Widget? succcessChild;
  const _WebViewPage({
    Key? key,
    required this.uri,
    required this.successUrl,
    required this.errorUrl,
    required this.afterPaymentBehaviour,
    this.errorChild,
    this.succcessChild,
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
    if (!response.isNothing &&
        widget.afterPaymentBehaviour ==
            AfterPaymentBehaviour.BeforeCalbacksExecution) {
      Navigator.of(context).pop(response);
    } else {
      setState(() {
        progress = 0;
      });
    }
  }

  void setError(Uri? uri, String message) {
    response = _getResponse(uri, false);
    if (!response.isNothing &&
        widget.afterPaymentBehaviour ==
            AfterPaymentBehaviour.BeforeCalbacksExecution) {
      Navigator.of(context).pop(response);
    } else {
      setState(() {
        progress = 0;
      });
    }
  }

  void setStop(Uri? uri) {
    response = _getResponse(uri, false);
    if (!response.isNothing &&
        widget.afterPaymentBehaviour ==
            AfterPaymentBehaviour.AfterCalbacksExecution) {
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
        body: Column(
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
                  assert((() {
                    print("Start: $uri");
                    return true;
                  })());
                  setStart(uri);
                },
                onLoadError: (InAppWebViewController controller, Uri? uri,
                    int status, String error) {
                  assert((() {
                    print("Error: $uri");
                    return true;
                  })());
                  setError(uri, error);
                },
                onLoadHttpError: (InAppWebViewController controller, Uri? uri,
                    int status, String error) {
                  assert((() {
                    print("HttpError: $uri");
                    return true;
                  })());
                  setError(uri, error);
                },
                onLoadStop: (InAppWebViewController controller, Uri? uri) {
                  assert((() {
                    print("Stop: $uri");
                    return true;
                  })());
                  setStop(uri);
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setProgress(progress);
                },
                onAjaxProgress:
                    (InAppWebViewController controller, request) async {
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
                  if (request.readyState == AjaxRequestReadyState.OPENED)
                    setStart(request.url);
                  else
                    setStop(request.url);
                  return request.action;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PaymentResponse _getResponse(Uri? uri, bool error) {
    if (uri == null) return PaymentResponse(PaymentStatus.None);
    var url = uri.toString();
    var isSuccess = url.contains(widget.successUrl);
    var isError = url.contains(widget.errorUrl);
    if (!isError && !isSuccess) return PaymentResponse(PaymentStatus.None);
    PaymentStatus status =
        isSuccess && !error ? PaymentStatus.Success : PaymentStatus.Error;

    return PaymentResponse(
      status,
      paymentId: uri.queryParameters["paymentId"],
      url: url,
    );
  }
}
