import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/pages/login.dart';
import 'package:whisper/services/shared-preferences.dart';

import '../constants/ip-for-services.dart';
import 'chat-page.dart';

class LoginWithGithub extends StatefulWidget {
  const LoginWithGithub({super.key});

  static const String id = '/LoginWithGitHub';

  @override
  State<LoginWithGithub> createState() => _LoginWithGithubState();
}

class _LoginWithGithubState extends State<LoginWithGithub> {
  late final WebViewController _controller;
  static const String id = '/LoginWithGithub';

  final String clientId = 'Iv23liQlV4tB3FkvC7JC';
  final String redirectUri = 'http://localhost:5173';
  late final String oauthUrl;

  @override
  void initState() {
    super.initState();

    // Construct the OAuth URL for GitHub
    oauthUrl = 'https://github.com/login/oauth/authorize'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&scope=user:email'
        '&prompt=select_account';

    // Create WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
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
                  final url = Uri.parse('http://$ip:5000/api/auth/github');
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
                  final data = jsonDecode(response.body);
                  if (data['status'] == 'success') {
                    await SaveToken(data['userToken']);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ChatPage.id,
                      (Route<dynamic> route) => false,
                    );
                  }
                } catch (e) {
                  print(e);
                }
                // Close the WebView and return the code
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(oauthUrl));

    if (!Platform.isMacOS) {
      _controller.setBackgroundColor(const Color(0x80000000));
    }

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

  Future<void> clearCookies() async {
    if (Platform.isAndroid) {
      await _controller.clearCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GitHub Sign-In"),
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
