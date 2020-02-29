import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends StatefulWidget {
  final String url;
  final String success;
  final String error;
  final bool forcePop;

  PaymentView({
    Key key,
    @required this.url,
    @required this.forcePop,
    @required this.success,
    @required this.error,
  }) : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var current = await _controller.currentUrl() ?? "";
        var success = current.contains(widget.success);
        Navigator.of(context).pop(success);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (String url) {
            if (widget.forcePop == true) {
              var isSuccess = url.contains(widget.success);
              var isError = url.contains(widget.error);
              if (isSuccess || isError) {
                Navigator.of(context).pop(isSuccess);
              }
            }
          },
          onWebViewCreated: (WebViewController controller) {
            _controller = controller;
          },
        ),
      ),
    );
  }
}
