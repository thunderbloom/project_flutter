import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:get/get.dart';
import 'package:project_flutter/controllers/global_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_flutter/pages/device_registration.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/main.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/noticeboard.dart';
import 'package:project_flutter/pages/show_user_db.dart';
import 'package:project_flutter/pages/settings.dart';
import 'package:project_flutter/pages/show_device_db.dart';
import 'package:project_flutter/pages/show_video_db.dart';
import 'package:project_flutter/widgets/current_weather_widget.dart';
import 'package:project_flutter/widgets/header_widget.dart';
import 'package:project_flutter/pages/video_play.dart';
import 'package:project_flutter/views/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/widgets/discover_card.dart';
import 'package:project_flutter/widgets/svg_asset.dart';
import 'package:project_flutter/widgets/icons.dart';
import 'package:badges/badges.dart';
import 'package:project_flutter/pages/show_history_db.dart';
import 'package:project_flutter/pages/login_page.dart' as login;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_flutter/mqtt/mqtt_client_connect.dart' as mqtt;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:project_flutter/pages/settings.dart';
import 'package:app_settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_flutter/pages/live_stream.dart';
import '../mqtt/mqtt_client_connect.dart';
// String userinfo = login.userinfo;

// String userinfo = login.userinfo;

class Loding extends StatefulWidget {
  const Loding({Key? key}) : super(key: key);

  @override
  _LodingState createState() => _LodingState();
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

class _LodingState extends State<Loding> {
  //------------------------------------------로그인 정보 가져오기---------------//
  String userinfo = '';
  String userIp = '';
  String username = '';
  // String userid = '';

  late MqttClient client;
  @override
  void initState() {
    super.initState();
    setData();
    setData2();
    setData3();
  }

  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isconnectedTrue = prefs.getBool('isConnectedTrue');
    
    late MqttClient client;
    final Mysql db = Mysql();
    if (isconnectedTrue == true){
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaa$isconnectedTrue');
    }else if(isconnectedTrue == false){
      connect().then((value) {
      // ------------------------MQTT 연결
      client = value;
      print('bbbbbbbbbbbbbbbbbbbbbbbbbbb$isconnectedTrue');
    });
    }else{};
    // connect().then((value) {
    //   // ------------------------MQTT 연결
    //   client = value;
    // });
    setState(() {
      userinfo = prefs.getString('id')!;
    });
    // print('여기까진 잘 됨 $userinfo');

    try {
      setState(() {
        final String? userinfo = prefs.getString('id');
      });
    } catch (e) {}

    await db.getConnection().then((conn) async {
      await conn
          .query(
        "SELECT ip FROM UserIp WHERE user_id = '$userinfo'",
      )
          .then((result) {
        String ip = result.toString();

        String userip = ip.substring(14, ip.length - 2); // db에 저장된 비밀번호

        prefs.setString('userip', userip);

        print(prefs.getString('userip'));
        // prefs.setString('password', pw);
      });
    });
  }

  void setData2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // late MqttClient client;
    final Mysql db = Mysql();
    // connect().then((value) {
    //   // ------------------------MQTT 연결
    //   client = value;
    // });
    setState(() {
      userinfo = prefs.getString('id')!;
    });

    try {
      setState(() {
        final String? userinfo = prefs.getString('id');
      });
    } catch (e) {}

    await db.getConnection().then((conn) async {
      await conn
          .query(
        "SELECT name FROM User WHERE user_id = '$userinfo'",
      )
          .then((result) {
        String name = result.toString();

        String username = name.substring(16, name.length - 2);

        prefs.setString('username', username);
        username = prefs.getString('username')!;
        print(prefs.getString('username'));
        print('zzzzzzzzzzzzzzzzzzzzzzzzzzz$username');
        // prefs.setString('password', pw);
      });
    });
  }

  void setData3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
    });
    try {
      setState(() {
        final String? username = prefs.getString('username');

        print(username);
      });
    } catch (e) {}
  }
  //-----------------------------------------------------------------여기까지---------------------

  void showAlertDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.BOTTOMSLIDE,
      title: '고객센터',
      desc: '전화연결 042-471-9222',
      //btnCancelOnPress: () {},
      showCloseIcon: true,
      btnOkText: '문의하기',
      btnOkOnPress: () async {
        Tel:
        launchUrl(Uri.parse('tel:042-471-9222'));
        final url = Uri.parse('tel:042-471-9222');
        if (await canLaunchUrl(url)) {
          launchUrl(url);
        } else {
          print("전화연결 실패 $url");
        }
        debugPrint('전화걸기 누름');
        Text('전화연결');
      },
      btnOkIcon: Icons.call,
    ).show();
  }

  //-----------------------------------------
  // loadCounter() async {
  //   // SharedPreferences의 인스턴스를 필드에 저장
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // late MqttClient client;
  //   final String? userid = prefs.getString('id');
  //   setState((){});

  //   // setState(() {
  //   //   // SharedPreferences에 counter로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
  //   //   final String? userid = (prefs.getString('id'));
  //   // });
  // print('여기까지 왔나 $userinfo');
  //     String userid2 = '$userid';
  //   //   return id;

  //   // });
  //   // String userid2 = '$userid';
  // }

  @override
  int _selectedIndex = 0;
  int pageIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  final RxBool _isLoading = true.obs;
//
//  //Future<void> UserID() async {
//  //  final prefs = await SharedPreferences.getInstance();
//  //  String? userid = prefs.getString('id');
//  //  print('userid:$userid');
//  //}
//
//  // Future<void> UserID() async {
//  //   final prefs = await SharedPreferences.getInstance();
//  //   String? userid = jsonEncode(prefs.getString('id'));
//  //   prefs.setString('id', userid);
//  // }
//
//  //Future<void> _UserID() async {
//  //  //final prefs = await SharedPreferences.getInstance();
//  //  String? id = jsonDecode(prefs.getString('id'));
//  //  return (userid);
//  //}

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'home',
      child: Container(
        // backgroundColor: Colors.white,
        // radius: 100.0,
        child: Image.asset('assets/images/winguardlogo.png'),
      ),
    );

    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WINGUARD'),
          centerTitle: true, // 중앙 정렬
          elevation: 0.0,
          actions: <Widget>[
            //IconButton(
            //  icon: Icon(Icons.shopping_cart), // 카트 아이콘 생성
            //  onPressed: () {
            //    // 아이콘 버튼 실행
            //    print('Shopping cart button is clicked');
            //  },
            //),
            IconButton(
                icon: Icon(Icons.home), // 검색 아이콘 생성
                onPressed: () async {
                  final url = Uri.parse(
                    'https://www.winguard.kr/main/main.php',
                  );
                  if (await canLaunchUrl(url)) {
                    launchUrl(url);
                  } else {
                    // ignore: avoid_print
                    print("Can't launch $url");
                  }
                  print('live streaming clicked');
                }),
          ],
          backgroundColor: Color(0xff1160aa),
        ), //보류 (필요없을거같음)
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  // 현재 계정 이미지 set
                  backgroundImage: AssetImage('assets/images/profile.png'),
                  backgroundColor: Colors.white,
                ), //fromARGB(255, 201, 231, 245)
                //otherAccountsPictures: <Widget>[
                //  // 다른 계정 이미지[] set
                //  CircleAvatar(
                //    backgroundColor: Colors.white,
                //    backgroundImage: AssetImage('assets/weather/01d.png'),
                //  ),
                //],

                accountName: Text("ID:$userinfo"),
                accountEmail: Text('$username 님 환영합니다'),
                onDetailsPressed: () {
                  print('arrow is clicked');
                },
                decoration: BoxDecoration(
                    color: Color(0xff1160aa), //s.red[200],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
              ),
              ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.grey[850],
                  ),
                  title: Text('회원정보'),
                  onTap: mypage),
              ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.grey[850],
                  ),
                  title: Text('환경설정'),
                  onTap: settingpage

                  //trailing: Icon(Icons.add),
                  ),
              ListTile(
                  leading: Icon(
                    Icons.support_agent,
                    color: Colors.grey[850],
                  ),
                  title: Text('고객센터'),
                  onTap: showAlertDialog
                  //() {
                  //  print('고객센터 is clicked');
                  //}
                  //trailing: Icon(Icons.add),
                  ),
              ListTile(
                  leading: Icon(
                    Icons.report, //question_answer,
                    color: Colors.grey[850],
                  ),
                  title: Text('공지사항'),
                  onTap: noticeboard
                  //     () async {
                  //   final url = Uri.parse(
                  //     'http://34.64.233.244:9797/notice',
                  //   );
                  //   if (await canLaunchUrl(url)) {
                  //     launchUrl(url);
                  //   } else {
                  //     // ignore: avoid_print
                  //     print("Can't launch $url");
                  //   }
                  //   print('live streaming clicked');
                  // }
                  ),
              SizedBox(
                height: 280,
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded, //question_answer,
                  color: Colors.grey[850],
                ),
                title: Text('로그아웃'),
                onTap: () async {
                  // print('로그아웃 is clicked');
                  final prefs = await SharedPreferences.getInstance();
                  //  prefs.setBool('isLoggedIn', false);
                  //  client.disconnect();
                  prefs.remove('id');
                  prefs.setBool('isLoggedIn', false);
                  // prefs.remove('password');
                  print('로그아웃');
                  //  WidgetsBinding.instance.addPostFrameCallback((_) async {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                  // });
                  // 로그아웃}
                  // () async{
                  //  final prefs = await SharedPreferences.getInstance();
                  //  prefs.setBool('isLoggedIn', false);
                  //  Navigator.push(
                  //      context,
                  //      MaterialPageRoute(
                  //          builder: (context) => LoginPage())); // 로그아웃
                  //  //print('로그아웃 is clicked');
                },
                // trailing: Icon(Icons.add),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Obx(
            () => globalController.checkLoading().isTrue
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 24.0, right: 24.0),
                        //--------새로한거------
                        physics: BouncingScrollPhysics(),
                        //--------------
                        children: <Widget>[
                          logo,
                          const HeaderWidget(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            child: Container(
                              child: CurrentWeatherWidget(
                                weatherDataCurrent: globalController
                                    .getWeatherData()
                                    .getCurrentWeather(),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 28),
                            child: Text(
                              "바로가기",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            height: 176,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(width: 15),
                                DiscoverCard(
                                  tag: "sensor",
                                  onTap: sensor,
                                  title: "알림내역",
                                  subtitle: "정보를 확인하세요!",
                                  icons: SvgAsset(
                                    assetName: AssetName.headphone,
                                    height: 24,
                                    width: 24,
                                  ),
                                  //--------------------------------
                                  icon: SvgAsset(),
                                  children: [],
                                  //--------------------------------
                                ),
                                SizedBox(width: 22),
                                DiscoverCard(
                                  tag: "cctv",
                                  onTap: cctv,
                                  title: "CCTV",
                                  subtitle: "실시간/녹화영상 확인",
                                  gradientStartColor: Color(0xffFC67A7),
                                  gradientEndColor: Color(0xffF6815B),
                                  icons: SvgAsset(
                                    assetName: AssetName.headphone,
                                    height: 50,
                                    width: 50,
                                  ),
                                  //--------------------------------
                                  icon: SvgAsset(),
                                  children: [],
                                  //--------------------------------
                                ),
                                SizedBox(width: 22),
                                DiscoverCard(
                                  tag: "register",
                                  onTap: adddevice1,
                                  title: "기기등록",
                                  subtitle: "자신의 기기를 등록하세요!",
                                  gradientStartColor: Color(0xff441DFC),
                                  gradientEndColor: Color(0xffF6815B),
                                  icons: SvgAsset(
                                    assetName: AssetName.headphone,
                                    height: 24,
                                    width: 24,
                                  ),
                                  //--------------------------------
                                  icon: SvgAsset(),
                                  children: [],
                                  //--------------------------------
                                ),
                                // SizedBox(width: 22),
                                // DiscoverCard(
                                //   onTap: adddevice2,
                                //   title: "기기등록",
                                //   subtitle: "+",
                                //   gradientStartColor: Color(0xff13DEA0),
                                //   gradientEndColor: Color(0xffF0B31A),
                                //   icons: SvgAsset(
                                //     assetName: AssetName.sensor,
                                //     height: 24,
                                //     width: 24,
                                //   ),
                                //   //--------------------------------
                                //   icon: SvgAsset(),
                                //   children: [],
                                //   //--------------------------------
                                // ),
                              ],
                            ),
                          ),
                        ]),
                  ),
          ),
        ),
      ),
    );
  }

  void sensor() {
    // Get.to(() => HomeScreen(), transition: Transition.rightToLeft);
    Get.to(() => const HistoryData(), transition: Transition.rightToLeft);
  }

  void cctv() {
    Get.to(() => const WebViewExample(), transition: Transition.rightToLeft);
  }

  void adddevice1() {
    Get.to(
        () => Device_re(
              title: 'device_re',
            ),
        transition: Transition.rightToLeft);
  }

  void adddevice2() {
    Get.to(() => const DeviceData(), transition: Transition.rightToLeft);
  }

  void mypage() {
    Get.to(() => const UserData(), transition: Transition.rightToLeft);
  }

  void noticeboard() {
    Get.to(() => const NoticeBoard(), transition: Transition.rightToLeft);
  }

  void settingpage() {
    Get.to(() => Setting(), transition: Transition.rightToLeft);
  }
}