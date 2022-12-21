import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:get/get.dart';
import 'package:project_flutter/controllers/global_controller.dart';
import 'package:flutter/cupertino.dart';
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

// import 'package:project_flutter/views/home_screen.dart';

class Loding extends StatefulWidget {
  const Loding({Key? key}) : super(key: key);
  @override
  _LodingState createState() => _LodingState();
}

class _LodingState extends State<Loding> {
  @override
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  //bool showElevatedButtonBadge = true;

  int _selectedIndex = 0;
  int pageIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  //-----------------------------------------------
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);
  //-----------------------------------------------
  final RxBool _isLoading = true.obs;
  //-------------------------------------
  //static const List<Widget> _widgetOptions = <Widget>[
  //  Text(
  //    'Index 0: Menu',
  //    style: optionStyle,
  //  ),
  //  Text(
  //    'Index 1: 알림',
  //    style: optionStyle,
  //  ),
  //  Text(
  //    'Index 2: My page',
  //    style: optionStyle,
  //  ),
  //];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xff1160aa)), //보류 (필요없을거같음)
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
                                  title: "sensor",
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

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: '알림',
              //icon: Stack(
              //  children: <Widget>[
              //    Icon(Icons.notifications),
              //    Positioned(
              //      right:0,
              //      child: Container(
              //        padding: EdgeInsets.all(1),
              //        decoration: BoxDecoration(
              //          color: Colors.red,
              //          borderRadius: BorderRadius.circular(6),
              //        ),
              //        constraints: BoxConstraints(
              //          minWidth: 12,
              //          minHeight: 12,
              //        ),
              //        child: Text('1'
              //        style: TextStyle(
              //          color:Colors.white,
              //          fontSize: 8,
              //        ),
              //        textAlign: TextAlign.center,
              //        ),
              //      ),
              //      ),
              //  ],
              //  ),
              //  label: '알림'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'My page',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xff1160aa),
          onTap: _onItemTapped,
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
}
