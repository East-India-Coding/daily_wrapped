import 'package:daily_wrapped/views/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/spotify_auth_notifier.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final provider = context.read<SpotifyAuthNotifier>();
    provider.getCodeFromWebView = _handleWebViewNavigation;
    await provider.userLogin();
    await provider.getUserDetails();
    if (provider.user != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (c) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SpotifyAuthNotifier>().user;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: const Color(0xffCFF469),
          child: Column(
            children: [
              Text('Daily Wrapped'),
              Text('Transforming your social feeds into a symphony'),
              ElevatedButton(
                onPressed: () async {
                  init();
                },
                child: Text('Spotify'),
              ),
              if (user != null)
                Column(
                  children: [
                    Text("${user.displayName}"),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _handleWebViewNavigation(String authUrl) async {
    final code = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => WebViewPage(url: authUrl, title: "Spotify Login")));
    return code;
  }
}
