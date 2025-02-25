import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/components/page_state.dart';
import 'package:whisper/constants/url.dart';
import 'package:whisper/services/shared_preferences.dart';
import '../constants/ip_for_services.dart';
import '../services/login_service.dart';
import '../services/show_loading_dialog.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  static const String id = '/LoginWithGoogle';

  @override
  State<LoginWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  late final WebViewController _controller;

  // Your OAuth Client ID for Android
  final String clientId =
      '17818726142-7fd5nu3iima7cf78kb1abf3shfuo4vqh.apps.googleusercontent.com';

  final String redirectUri = 'http://localhost:5173';
  late final String oauthUrl;

  @override
  void initState() {
    super.initState();

    oauthUrl = 'https://accounts.google.com/o/oauth2/v2/auth'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&response_type=code'
        '&scope=email profile'
        '&prompt=select_account';

    // Create WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          "Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.82 Mobile Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith(redirectUri)) {
              Uri uri = Uri.parse(request.url);
              String? code = uri.queryParameters["code"];
              if (code != null) {
                debugPrint("Authorization code: $code");
                try {
                  final url = Uri.parse('$domain_name/auth/google');
                  showLoadingDialog(context);
                  final response = await http.post(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode(
                      {
                        "code": code,
                      },
                    ),
                  );
                  Navigator.pop(context);

                  final data = jsonDecode(response.body);
                  if (data['status'] == 'success') {
                    await saveToken(data['userToken']);
                    await saveId(data['user']['id']);
                    try {
                      String? firebaseToken =
                          await FirebaseMessaging.instance.getToken();
                      await LoginService.registerFCMToken(
                          firebaseToken, data['userToken'], context);
                    } catch (e) {
                      print(e);
                    }
                    await saveRole("User");
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      PageState.id,
                      (Route<dynamic> route) => false,
                    );
                    // Close the WebView and return the code
                  }
                } catch (e) {
                  print(e);
                }
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(oauthUrl));

    // Set background color
    if (!Platform.isMacOS) {
      _controller.setBackgroundColor(const Color(0x80000000));
    }

    // Listen for deep links
    AppLinks appLinks = AppLinks();
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null &&
          uri.scheme == 'whisperSeifMohamed' &&
          uri.host == 'oauth2redirect') {
        String? code = uri.queryParameters['code'];
        if (code != null) {
          debugPrint("Authorization code from deep link: $code");
          Navigator.pop(context, code);
        }
      }
    });
  }

  // Function to clear cookies for sign-in
  Future<void> clearCookies() async {
    if (Platform.isAndroid) {
      await _controller.clearCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign-In"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              clearCookies().then((_) {
                _controller.loadRequest(Uri.parse(oauthUrl));
              });
            },
          )
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
