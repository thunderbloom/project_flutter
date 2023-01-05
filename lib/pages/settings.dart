import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:project_flutter/main.dart';
import 'package:project_flutter/mqtt/mqtt_client_connect.dart';
import 'package:project_flutter/pages/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';
// void main() {
//   var isLoggedIn;
//   runApp(MaterialApp(
//     home: MyApp(
//       isLoggedIn: isLoggedIn,
//     ),
//   ));
// }

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);
  @override
  SettingPage createState() => SettingPage();
}

class SettingPage extends State<Setting> {
  // final _instance = OneSignal.shared;
  // final String appID;
  //void onoff() async {
  //  SharedPreferences prefs = await SharedPreferences.getInstance();
  //}

  //Future<void> cancelAllNotifications() async {
  //  await flutterLocalNotificationsPlugin.cancelAll();
  //}

  //void add() async {
  //  if (notificaation == true) {
  //    await NotificationService().init();
  //  } else {
  //    await flutterLocalNotificationsPlugin.cancelAll();
  //  }
  //}

  //late LocationPermission permission;
  //Future<LocationPermission> locationPermission = Geolocator.checkPermission();

  //late MqttClient client;
  //late MqttClient client;

  // MqttClient client;
  //Future Mqttdis() async {
  //  late MqttClient client;
  //  connect().then((value) {
  //    client = value;
  //  });
  //}

  //MqttServerClient client =
  //  MqttServerClient.withPort('34.64.233.244', 'ayWebSocketClient_123456_33f7423c-a3b7-46b1-8a1a-26937e4a071faa', 19883);
  var notificaation = true;
  var locationbutton = true;
  bool mqttbutton = true;
  //bool status1 = false;
  //@override
  //void initState() {
  //  super.initState();
  //  MqttClient client;
  //}

  MqttClient? client;
//
  //@override
  //void dispose() {
  //  super.dispose();
  //}

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //void dispose() async {
  //  super.dispose();
  //}
  //var newValue3 = mqttbutton;
  //bool valSetting4 = true;
  //client.disconnect();
  //void dasda(){
  //  mqttbutton == false? client.disconnect();
  //}
  //void add() {
  //  if (mqttbutton == false) {
  //    client.disconnect();
  //  } else {
  //    connect().then((value) {
  //      client = value;
  //    });
  //  }
  //}

  onChangeFunction1(var newValue1) {
    setState(() {
      notificaation = newValue1;

      // if (notificaation == false) {
      //   flutterLocalNotificationsPlugin.cancelAll();
      //   print('알림 꺼짐');
      // } else {
      //   print('알림 켜짐');
      // }
      if (notificaation == false) {
        // _cancelAllNotifications;
        AppSettings.openNotificationSettings();
        print('알림 꺼짐');
      } else {
        AppSettings.openNotificationSettings();
        print('알림 켜짐');
      }
    });
  }

  // void add() async {
  //   if (notificaation == false) {
  //     await flutterLocalNotificationsPlugin.cancelAll();
  //     print('알림 꺼짐');
  //     //await NotificationService().init();
  //   } else {
  //     //await flutterLocalNotificationsPlugin.cancelAll();
  //     //print('알림 꺼짐');
  //   }
  // }

  onChangeFunction2(var newValue2) {
    setState(() {
      locationbutton = newValue2;
      if (notificaation == false) {
        // _cancelAllNotifications;
        AppSettings.openLocationSettings();
        print('알림 꺼짐');
      } else {
        AppSettings.openLocationSettings();
        print('알림 켜짐');
      }
    });
  }

  onChangeFunction3(bool newValue3) {
    setState(() {
      mqttbutton = newValue3;

      if (mqttbutton == true) {
        connect().then((value) {
          client = value;
        });
        print('연결');
      } else {
        client?.disconnect();
        print('연결 해제');
      }
    });
  }

  // onChangeFunction4(bool newValue4) {
  //   setState(() {
  //     valSetting1 = newValue4;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            '환경설정',
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.white,
              icon: Icon(Icons.arrow_back)), // 중앙 정렬
          elevation: 0.0,
          backgroundColor: Color(0xff1160aa),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(//mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                //Icon(
                //  Icons.settings,
                //  color: Colors.blue,
                //),
                SizedBox(width: 10),
                // Text(
                //   '설정',
                //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                // )
              ],
            ),
            //Divider(
            //  height: 20,
            //  thickness: 2,
            //),
            SizedBox(
              height: 10,
            ),
            // Padding(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            //     child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text('asd',
            //               style: TextStyle(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.w500,
            //                   color: Colors.black)),
            //           Transform.scale(
            //             scale: 0.9,
            //             child: CupertinoSwitch(
            //               activeColor: Colors.blue,
            //               value: status1,
            //               onChanged: (bool newValue) {
            //                 setState(() {
            //                   status1;
            //                 });
            //               },
            //             ),

            //           )
            //         ])),

            buildSettingOption('알림설정', notificaation, onChangeFunction1),

            buildSettingOption('위치정보', locationbutton, onChangeFunction2),
            buildSettingOption('센서연결', mqttbutton, onChangeFunction3),

            SizedBox(
              height: 400,
            ),
            Container(
              alignment: Alignment.center,
              child: Text('버전정보'),
            ),
            Container(
              alignment: Alignment.center,
              child: Text('윈가드 1.0.0'),
            ),
            //buildSettingOption('알림', valSetting4, onChangeFunction4),
            //Container(
            //  alignment: Alignment.centerLeft,
            //  child: Text(
            //    "알림 기능",
            //  ),
            //),
            ////SizedBox(
            ////  height: 70,
            ////),
            //FlutterSwitch(
            //  value: status1,
            //  //showOnOff: true,
            //  onToggle: (val) {
            //    setState(() {
            //      status1 = val;
            //    });
            //  },
            //),
            //Container(
            //  alignment: Alignment.centerRight,
            //  child: Text(
            //    "Value: $status1",
            //  ),
            //),
          ]),
        ),
      ),
    );
  }

  Padding buildSettingOption(
      String title, bool value, Function onchangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        Transform.scale(
          scale: 0.9,
          child: CupertinoSwitch(
            activeColor: Colors.blue,
            value: value,
            onChanged: (bool newValue) {
              onchangeMethod(newValue);
            },
          ),
        )
      ]),
    );
  }
}
