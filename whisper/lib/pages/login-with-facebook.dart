import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWithFacebook extends StatefulWidget {
  const LoginWithFacebook({super.key});

  static String id = "/loginWithFacebook";

  @override
  State<LoginWithFacebook> createState() => _LoginWithFacebookState();
}

class _LoginWithFacebookState extends State<LoginWithFacebook> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse('http://10.0.2.2:5000/api/auth/facebook'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
