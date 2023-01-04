import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/video_play.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_flutter/pages/data_table.dart';

void main() => runApp(const MaterialApp(home: WebViewExample()));

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController controller;
  String userinfo = '';
  String userIp = '';

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

  void showAlertDialog1(int) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.BOTTOMSLIDE,
      title: '신고하기',
      desc: '정말 신고하시겠습니까?',
      btnCancelText: '취소',
      btnOkText: '신고하기',
      btnCancelOnPress: () {},
      showCloseIcon: true,
      btnOkOnPress: () async {
        Tel:
        launchUrl(Uri.parse('tel:112'));
        final url = Uri.parse('tel:112');
        if (await canLaunchUrl(url)) {
          launchUrl(url);
        } else {
          print("전화연결 실패 $url");
        }
        debugPrint('신고하기 누름');
        Text('전화연결');
      },
      btnOkIcon: Icons.call,
    ).show();
  }

  Future<void> webviews() async {
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
      ) //http://192.168.41.191:5000
      ..loadRequest(Uri.parse('$userIp'));
    if (controller != null) {
      controller = controller;
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
      appBar: AppBar(
        title: Text("CCTV"),
        backgroundColor: Color(0xff1160aa),
        actions: <Widget>[
          TextButton(
              child: Image.asset(
                'assets/icons/rec.png',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoPlay()),
                );
              })
        ],
      ),
      body: WebViewWidget(controller: controller),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/report.png',
                width: 40,
                height: 40,
              ),
              label: '신고하기',
            ),
          ],
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          selectedItemColor: Colors.black,
          onTap: showAlertDialog1
          //  (value) async {
          //   Tel:
          //   launchUrl(Uri.parse('tel:112'));
          //   final url = Uri.parse('tel:112');
          //   if (await canLaunchUrl(url)) {
          //     launchUrl(url);
          //   } else {
          //     print("전화연결 실패 $url");
          //   }
          //   debugPrint('신고하기 누름');
          // },
          ),
    );
  }
}
