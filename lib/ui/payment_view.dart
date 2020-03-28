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

class __PaymentViewState extends State<_PaymentView>
    with SingleTickerProviderStateMixin {
  WebViewController _controller;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
      value: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animationController.value == 1) return false;
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
                  _animationController.forward();
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
                  _animationController.animateBack(0);
                },
                onWebViewCreated: (WebViewController controller) {
                  _controller = controller;
                },
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget child) {
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: MediaQuery.of(context).size.height *
                      _animationController.value,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _animationController.value,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor ??
                          Theme.of(context).backgroundColor,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                );
              },
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
