import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController controller;
  bool isPageLoading = true;

  Future<void> _refreshWebView() async {
    setState(() {
      isPageLoading = true;
    });
    await controller.reload();
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://therafi.me'),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          await controller.goBack();
          return false; // Prevent app from exiting
        }
        return true; // Let the app exit
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("The Rafi"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
          child: Theme(
            data: ThemeData.dark(),
            child: Stack(
              children: [
                WebViewWidget(
                  controller: controller,
                ),
                RefreshIndicator(
                  onRefresh: _refreshWebView,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late WebViewController controller;



//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (await controller.canGoBack()) {
//           await controller.goBack();
//           return false; // Prevent app from exiting
//         }
//         return true; // Let the app exit
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("The Rafi"),
//           centerTitle: true,
//           backgroundColor: Colors.black,
//         ),
//         body: SafeArea(
//           child: Theme(
//             data: ThemeData.dark(),
//             child: Stack(
//               children: [
//                 WebView(
//                   initialUrl: 'https://therafi.me',
//                   javascriptMode: JavascriptMode.unrestricted,
//                   onWebViewCreated: (WebViewController webViewController) {
//                     controller = webViewController;
//                   },
//                 ),
               
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
