library flutter_recaptcha_v2;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:whisper/components/custom-highlight-text.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/modules/signup-credentials.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/services/signup.dart';

class Recaptcha extends StatefulWidget {
  final String apiKey;
  final String? apiSecret;
  final String pluginURL;
  final RecaptchaV2Controller controller;
  final ValueChanged<bool>? onVerifiedSuccessfully;
  final ValueChanged<String>? onVerifiedError;
  final ValueChanged<String>? onManualVerification;
  static const String id = "/Recaptcha";

  Recaptcha({
    required this.apiKey,
    this.apiSecret,
    this.pluginURL = "https://recaptcha-flutter-plugin.firebaseapp.com/",
    RecaptchaV2Controller? controller,
    this.onVerifiedSuccessfully,
    this.onVerifiedError,
    this.onManualVerification,
  })  : controller = controller ?? RecaptchaV2Controller(),
        assert(apiKey != null, "Google ReCaptcha API KEY is missing.");

  @override
  State<StatefulWidget> createState() => _RecaptchaState();
}

class _RecaptchaState extends State<Recaptcha> {
  late RecaptchaV2Controller controller;
  late final WebViewController _controller;

  void verifyToken(String token) async {
    await SaveRobotToken(token);
    await signup(context);
  }

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final WebViewController webControll =
        WebViewController.fromPlatformCreationParams(params);
    webControll
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(firstNeutralColor)
      ..addJavaScriptChannel(
        'RecaptchaFlutterChannel',
        onMessageReceived: (JavaScriptMessage receiver) {
          String _token = receiver.message;
          if (_token.contains("verify")) {
            _token = _token.substring(7);
          }
          verifyToken(_token);
        },
      )
      ..loadRequest(Uri.parse("${widget.pluginURL}?api_key=${widget.apiKey}"));
    _controller = webControll;
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstNeutralColor,
      body: Column(
        children: [
          Container(
            height: 300, // You can adjust the height if needed
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Align(
              child: WebViewWidget(controller: _controller),
              alignment: Alignment.center,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: CustomHighlightText(
              callToActionText: "Go Back",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

}
