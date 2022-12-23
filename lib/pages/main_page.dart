import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:get/get.dart';
import 'package:project_flutter/controllers/global_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_flutter/main.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/pages/mypage.dart';
import 'package:project_flutter/pages/show_device_db.dart';
import 'package:project_flutter/pages/show_video_db.dart';
import 'package:project_flutter/widgets/current_weather_widget.dart';
import 'package:project_flutter/widgets/header_widget.dart';
import 'package:project_flutter/pages/video_play.dart';

import 'package:project_flutter/views/home_screen.dart';
// import 'package:project_flutter/mqtt/mqtt_client_connect.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_flutter/widgets/discover_card.dart';
import 'package:project_flutter/widgets/svg_asset.dart';
import 'package:project_flutter/widgets/icons.dart';
import 'package:badges/badges.dart';
import 'package:project_flutter/pages/show_history_db.dart';
import 'package:project_flutter/pages/mypage.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Loding extends StatefulWidget {
  const Loding({Key? key}) : super(key: key);
  @override
  _LodingState createState() => _LodingState();
}

class _LodingState extends State<Loding> {
  @override
  //int _counter = 0;
  //void _incrementCounter() {
  //  setState(() {
  //    _counter++;
  //  });
  //}

  //bool showElevatedButtonBadge = true;

  int _selectedIndex = 0;
  int pageIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  final RxBool _isLoading = true.obs;

  //static final List<GetPage> pages = [
  //// ...
  //  GetPage(
  //    name: SearchScreen.name,
  //    page: () => DrawerScreen(),
  //    binding: SearchBarBinding(),
  //  ),
  //];

  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('윈가드'),
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
              icon: Icon(Icons.search), // 검색 아이콘 생성
              onPressed: () {
                // 아이콘 버튼 실행
                print('Search button is clicked');
              },
            ),
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
                  backgroundImage: AssetImage('assets/weather/01d.png'),
                  backgroundColor: Colors.white,
                ),
                //otherAccountsPictures: <Widget>[
                //  // 다른 계정 이미지[] set
                //  CircleAvatar(
                //    backgroundColor: Colors.white,
                //    backgroundImage: AssetImage('assets/weather/01d.png'),
                //  ),
                //],
                accountName: Text('team3'),
                accountEmail: Text('logenzes@gmail.com'),
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
                  title: Text('회원정보 수정'),
                  onTap: mypage
                  //() {
                  //  Navigator.push(context,
                  //      MaterialPageRoute(builder: (context) => MyPage4()));
                  //  //print('회원정보 수정 is clicked');
                  //},
                  //trailing: Icon(Icons.add),
                  ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey[850],
                ),
                title: Text('환경설정'),
                onTap: () {
                  print('환경설정 is clicked');
                },
                //trailing: Icon(Icons.add),
              ),
              ListTile(
                leading: Icon(
                  Icons.support_agent,
                  color: Colors.grey[850],
                ),
                title: Text('고객센터'),
                onTap: () {
                  print('고객센터 is clicked');
                },
                //trailing: Icon(Icons.add),
              ),
              ListTile(
                leading: Icon(
                  Icons.report, //question_answer,
                  color: Colors.grey[850],
                ),
                title: Text('공지사항'),
                onTap: () {
                  print('공지사항 is clicked');
                },
                //trailing: Icon(Icons.add),
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
                  onTap: () {
                    print('로그아웃 is clicked');
                  }
                  //() async{
                  //  final prefs = await SharedPreferences.getInstance();
                  //  prefs.setBool('isLoggedIn', false);
                  //  Navigator.push(
                  //      context,
                  //      MaterialPageRoute(
                  //          builder: (context) => LoginPage())); // 로그아웃
                  //  //print('로그아웃 is clicked');
                  //},
                  //trailing: Icon(Icons.add),
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
                          Text(
                              textAlign: TextAlign.center,
                              '우리집 수호천사',
                              style: TextStyle(
                                  color: Color(0xff1160aa),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          //-------------------
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
                                  // tag: "sensor",
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
                                  onTap: cctv,
                                  title: "CCTV",
                                  subtitle: "녹화영상 확인",
                                  gradientStartColor: Color(0xffFC67A7),
                                  gradientEndColor: Color(0xffF6815B),
                                  icons: SvgAsset(
                                    assetName: AssetName.sensor,
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
                                  onTap: adddevice1,
                                  title: "기기등록",
                                  subtitle: "+",
                                  gradientStartColor: Color(0xff441DFC),
                                  gradientEndColor: Color(0xffF6815B),
                                  icons: SvgAsset(
                                    assetName: AssetName.sensor,
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
                                  onTap: adddevice2,
                                  title: "기기등록",
                                  subtitle: "+",
                                  gradientStartColor: Color(0xff13DEA0),
                                  gradientEndColor: Color(0xffF0B31A),
                                  icons: SvgAsset(
                                    assetName: AssetName.sensor,
                                    height: 24,
                                    width: 24,
                                  ),
                                  //--------------------------------
                                  icon: SvgAsset(),
                                  children: [],
                                  //--------------------------------
                                ),
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
    Get.to(() => VideoPlay(), transition: Transition.rightToLeft);
  }

  void adddevice1() {
    Get.to(() => VideoData(), transition: Transition.rightToLeft);
  }

  void adddevice2() {
    Get.to(() => DeviceData(), transition: Transition.rightToLeft);
  }

  void mypage() {
    Get.to(() => MyPage4(), transition: Transition.rightToLeft);
  }
}
