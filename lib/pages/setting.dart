import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:project_flutter/mqtt/mqtt_client_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
//void main() {
//  runApp(MaterialApp(
//    home: MyApp(),
//  ));
//}


class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);
  @override
  SettingPage createState() => SettingPage();
}

class SettingPage extends State<Setting> {
  //bool status1 = false;
  late MqttClient client;
  //Future Mqttdis() async {
  //  late MqttClient client;
  //  connect().then((value) {
  //    client = value;
  //  });
  //}
  //------------------------------------------로그인 정보 가져오기---------------//
  // bool? connectinfo;
  
  late bool isConnectedTrue;
  late bool isConnectedFalse;
  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isConnectedTrue = prefs.getBool('isConnectedTrue')!;
      isConnectedFalse= prefs.getBool('isConnectedFalse')!;
    });
    print('여기까지 됨 $isConnectedTrue');
    // try {
    //   setState(() {
    //     final String? userinfo = prefs.getString('connected');        
    //   });
    // } catch (e) {}
  }
  //-----------------------------------------------------------------여기까지---------------------

  //MqttServerClient client =
  //  MqttServerClient.withPort('34.64.233.244', 'ayWebSocketClient_123456_33f7423c-a3b7-46b1-8a1a-26937e4a071faa', 19883);
  bool notification = true;
  bool locationbutton = true;
  // late bool mqttbutton;
   
  bool mqttbutton = true;
  // isConnected ? bool mqttbutton = true : bool mqttbutton = false;
  
  // void mqtt(){
  //   if (isConnected == true){
  //     bool mqttbutton = true;
  //   } else {
  //     bool mqttbutton = false;
  //   }
  // }
  //var newValue3 = mqttbutton;
  //bool valSetting4 = true;
  //client.disconnect();
  //void dasda(){
  //  mqttbutton == false? client.disconnect();
  //}
  // void add() {
  //   if (mqttbutton = false) {
  //     client.disconnect();
  //   } else {
  //     connect().then((value) {
  //       client = value;
  //     });
  //   }
  // }

  onChangeFunction1(bool newValue1) {
    setState(() {
      notification = newValue1;
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      locationbutton = newValue2;
      print('됨');
    });
  }

  onChangeFunction3(bool newValue3) {
    setState(() {
      mqttbutton = newValue3;
      // // print('켜짐');
      // // client.disconnect(); 
      // if (isConnectedTrue==true)  {   
      //     if (newValue3==true){
      //       client.disconnect();
      //       print(isConnectedTrue);          
      //     } else {      
      //     print(isConnectedTrue);
      //     // client.disconnect();
      //     }
      // }
      // else if(isConnectedFalse==true){
      //   if (newValue3==true){
      //     connect().then((value) {                  
      //             client = value;
      //           });
      //     print(isConnectedFalse);
      //   } else {
      //     print(isConnectedFalse);
      //   }       
         
    // }
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.white,
              icon: Icon(Icons.arrow_back)),
          centerTitle: true, // 중앙 정렬
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
            buildSettingOption('알림', notification, onChangeFunction1),
            buildSettingOption('위치정보', locationbutton, onChangeFunction2),
            buildSettingOption('mqtt 접속', mqttbutton, onChangeFunction3),

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
  // Padding buildSettingOption(
  //     String title, bool value, Function onchangeMethod) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
  //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //       Text(title,
  //           style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black)),
  //       Transform.scale(
  //         scale: 0.9,
  //         child: CupertinoSwitch(
  //           activeColor: Colors.blue,
  //           value: value,
  //           onChanged: (bool Value) {
  //             setState(() {
  //               Value;
  //             });
  //             //onchangeMethod(newValue);
  //           },
  //         ),
  //       )
  //     ]),
  //   );
  // }
}