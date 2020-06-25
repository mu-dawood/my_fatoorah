part of my_fatoorah;

class _WebViewPage extends StatefulWidget {
  final String url;

  const _WebViewPage({Key key, this.url}) : super(key: key);
  @override
  __WebViewPageState createState() => __WebViewPageState();
}

class __WebViewPageState extends State<_WebViewPage> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  bool loading = true;
  @override
  void initState() {
    flutterWebviewPlugin.onStateChanged.listen((state) {
      print("\u001b[31mWeView=> ${state.type}");
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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
}
