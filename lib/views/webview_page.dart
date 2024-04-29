import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../providers/spotify_auth_notifier.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  String? title;
  String? currentUrl;
  final controller = WebViewController();

  @override
  void initState() {
    super.initState();
    title = widget.title;
    currentUrl = widget.url;
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            if (url.startsWith("https://toseefkhan403.github.io")) {
              final code = (url.split("?code=")[1]);
              Navigator.pop(context, code);
            }
          },
          onPageFinished: (String url) async {
            final pageTitle = await controller.getTitle();
            final pageUrl = await controller.currentUrl();
            title =
                pageTitle != null && pageTitle.isNotEmpty ? pageTitle : title;
            currentUrl =
                pageUrl != null && pageUrl.isNotEmpty ? pageUrl : currentUrl;
            if (mounted) setState(() {});
            if (!mounted) return;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$title"),
              Text(
                "$currentUrl",
              )
            ],
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
