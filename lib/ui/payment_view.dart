part of my_fatoorah;

class _PaymentView extends StatefulWidget {
  final String url;
  final String success;
  final String error;
  final AfterPaymentBehaviour afterPaymentBehaviour;

  _PaymentView({
    Key key,
    @required this.url,
    @required this.afterPaymentBehaviour,
    @required this.success,
    @required this.error,
  }) : super(key: key);

  @override
  __PaymentViewState createState() => __PaymentViewState();
}

class __PaymentViewState extends State<_PaymentView> {
  WebViewController _controller;
  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_loading) return false;
        var current = await _controller.currentUrl() ?? "";
        Navigator.of(context).pop(getResponse(current));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (String url) {
                  if (widget.afterPaymentBehaviour ==
                      AfterPaymentBehaviour.BeforeCalbacksExecution) {
                    var response = getResponse(url);
                    if (response != null) {
                      Navigator.of(context).pop(response);
                      return;
                    }
                  }
                  setState(() {
                    _loading = true;
                  });
                },
                onPageFinished: (String url) {
                  if (widget.afterPaymentBehaviour ==
                      AfterPaymentBehaviour.AfterCalbacksExecution) {
                    var response = getResponse(url);
                    if (response != null) {
                      Navigator.of(context).pop(response);
                      return;
                    }
                  }
                  setState(() {
                    _loading = false;
                  });
                },
                onWebViewCreated: (WebViewController controller) {
                  _controller = controller;
                },
              ),
            ),
            AnimatedPositioned(
              left: 0,
              right: 0,
              top: 0,
              duration: Duration(milliseconds: 300),
              height: _loading ? MediaQuery.of(context).size.height : 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _loading ? 1 : 0,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor ??
                      Theme.of(context).backgroundColor,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PaymentResponse getResponse(String url) {
    Uri uri = Uri.parse(url);
    var isSuccess = url.contains(widget.success);
    var isError = url.contains(widget.error);
    if (!isError && !isSuccess) return null;
    PaymentStatus status =
        isSuccess ? PaymentStatus.Success : PaymentStatus.Error;
    return PaymentResponse(status, uri.queryParameters["paymentId"]);
  }
}
