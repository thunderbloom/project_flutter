import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_flutter/pages/data_table.dart';

void main() => runApp(const MaterialApp(home: WebViewExample()));

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  
  //------------------------------------------로그인 정보 가져오기---------------//
  String userinfo = '';
  String userIp = '';
  //String _controller = '';
  // String ip = '';
  late  WebViewController controller;
  //WebViewController? controller;
    


  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userinfo = prefs.getString('id')!;
      userIp = prefs.getString('userip')!;
    }); 
    try {
      setState(() {
        final String? userinfo = prefs.getString('id');  
        final String? userIp = prefs.getString('userip');   
        print(userIp);
      });
    } catch (e) {}
  }

  Future<void> webviews()async{
  controller = await WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )//http://192.168.41.191:5000
      // ..loadRequest(Uri.parse('http://34.64.233.244:9797/notice/'));
      ..loadRequest(Uri.parse('http://192.168.41.191:5000'));
      if (controller !=null){
      controller=controller;
    }

      print('22222221333333331111111111111111111111111111111111$userIp');
    print("22222221333333331111111111111111111111111111111111$userinfo");
  }
  @override
  void initState() {
    setData();
    webviews();        
    super.initState();
  }

  // #docregion webview_widget
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: controller),
                                    //controller!
    );
  }
  
  
  
  // #enddocregion webview_widget
}
