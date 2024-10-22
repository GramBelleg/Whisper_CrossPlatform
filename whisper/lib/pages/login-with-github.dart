import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWithGithub extends StatefulWidget {
  const LoginWithGithub({super.key});

  static String id = "/loginWithGithub";

  @override
  State<LoginWithGithub> createState() => _LoginWithGithubState();
}

class _LoginWithGithubState extends State<LoginWithGithub> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse('http://10.0.2.2:5000/api/auth/github'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
