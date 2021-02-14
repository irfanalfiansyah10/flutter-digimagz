import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;
import 'package:flutter/material.dart';

class WebView extends StatefulWidget {
  final String url;

  WebView(this.url);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Image.asset("assets/images/logo_toolbar.png"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: (){
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          },
        ),
      ),
      body: wv.WebView(
        initialUrl: widget.url,
        javascriptMode: wv.JavascriptMode.unrestricted,
      ),
    );
  }
}
