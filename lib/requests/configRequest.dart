import 'package:flutter/material.dart';

class ConfigRequest {
  final String baseUrl;
  final String token;
  final String title;
  final Color toolBarTitleColor;
  final Color toolBarBackgroundColor;

  ConfigRequest({
    @required this.baseUrl,
    @required this.token,
    this.title = "My fatoorah payment",
    this.toolBarTitleColor = Colors.white,
    this.toolBarBackgroundColor = Colors.blueAccent,
  });

  String _colorHex(Color c) {
    var r = c.red.toRadixString(16);
    var g = c.green.toRadixString(16);
    var b = c.blue.toRadixString(16);
    var a = (c.alpha).toRadixString(16);

    if (r.length == 1) r = "0" + r;
    if (g.length == 1) g = "0" + g;
    if (b.length == 1) b = "0" + b;
    if (a.length == 1) a = "0" + a;

    return "#" + r + g + b + a;
  }

  Map<String, dynamic> tojson() {
    return {
      "baseUrl": baseUrl,
      "token": token,
      "title": title,
      "toolBarTitleColor": _colorHex(toolBarTitleColor),
      "toolBarBackgroundColor": _colorHex(toolBarBackgroundColor),
    };
  }
}
