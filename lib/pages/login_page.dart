import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:project_flutter/pages/device_page.dart';
import 'package:project_flutter/pages/reset_pw_page.dart';
import 'package:project_flutter/pages/sign_up.dart';
import 'package:project_flutter/pages/show_device_db.dart';
import 'package:project_flutter/pages/show_user_db.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:crypto/src/sha256.dart' as sha;
import 'package:project_flutter/pages/main_page.dart';
import 'package:project_flutter/views/home_screen.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:project_flutter/mqtt/mqtt_client_connect.dart';


void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final db = Mysql();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  


  Future singIn() async {

    await db.getConnection().then((conn) async {
      await conn
          .query("SELECT Password FROM User WHERE user_id = '${idController.text}'")
          .then((password) {
        id:
        idController.text.toString();
        password:
        passwordController.text.toString();
      });
    });   
  }

  Future<List<Profiles>> getSQLData() async {
    final List<Profiles> profileList = [];
    final Mysql db = Mysql();
    late MqttClient client;
    var topic = "house/door";

    // await connect().then((value) {
    //                   client = value;
    //                 });
    
    // await client.subscribe(topic, MqttQos.atLeastOnce);
 
    await db.getConnection().then((conn) async {
      String test = idController.text.toString();
      await conn
          .query("SELECT Password FROM User WHERE user_id = '${idController.text}'")
          .then((result) {
        String pass = result.toString();
        String test_pass = passwordController.text.toString();
        String pw = pass.substring(20, pass.length - 2); // db에 저장된 비밀번호

        Digest decrpyted_password = decrypt(); //추가

        String pass_decrypt = decrpyted_password.toString(); // 추가

        if (pw == pass_decrypt) {
          print("패스워드 일치");
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Loding()));
          
          connect().then((value) {  // ------------------------MQTT 연결
                      client = value;
                    });
          client.subscribe(topic, MqttQos.atLeastOnce);
        } else
          setState(() {
            print("패스워드 불일치");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("비밀번호가 틀립니다."),
              duration: Duration(milliseconds: 700),
            ));
          });
      });
      setState(() {});
    });
    return profileList;
  }

  Digest decrypt() {
    var bytes = utf8.encode('${passwordController.text}');

    Digest sha256Result = sha.sha256.convert(bytes);

    return sha256Result;
  }

  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
        tag: 'home',
        child: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: 48.0,
          child: Image.asset('assets/images/temp_logo.jpg'),
        ));

    final id = TextFormField(
      controller: idController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: '아이디',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '아이디를 입력해주세요.';
        }
        return null;
      },
    );

    final password = TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
          hintText: '비밀번호',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (String? value) {
        if (value!.isEmpty) {
          return '비밀번호를 입력해주세요.';
        }
        return null;
      },
    );

    final loginButton = Padding(
        padding: EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: singIn, 
          child: MaterialButton(
            minWidth: 200.0,
            height: 48.0,
            onPressed: () {
              getSQLData();
            },
            color: Color(0xff11600aa),
            child: Text('로그인', style: TextStyle(color: Colors.white)),
          ),
        ));

    final findPW = ButtonBar(
      alignment: MainAxisAlignment.center,
      buttonPadding: EdgeInsets.all(20),
      children: [
        TextButton(
            child: const Text('회원가입',
                style: TextStyle(color: Color.fromARGB(214, 0, 0, 0))),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Sign_up()));
            }),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage()));
            },
            child: Text('비밀번호 찾기',
                style: TextStyle(color: Color.fromARGB(214, 0, 0, 0))))
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 24.0),
            Text('우리집 수호 천사',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 24.0,
            ),
            id,
            SizedBox(
              height: 8.0,
            ),
            password,
            SizedBox(
              height: 24.0,
            ),
            loginButton,
            findPW,
          ],
        ),
      ),
    );
  }
//---------------------------------------------------삭제--------------------
  // FutureBuilder<List> getDBdata() {
  //   return FutureBuilder<List>(builder: (context, snapshot) {
  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return const CircularProgressIndicator();
  //     } else if (snapshot.hasError) {
  //       return Text(snapshot.error.toString());
  //     }
  //     return MaterialApp(
  //       title: 'Login',
  //       debugShowCheckedModeBanner: false,
  //       home: Scaffold(
  //         body: Container(
  //             padding: EdgeInsets.fromLTRB(20, 120, 20, 120),
  //             child: Column(
  //               children: <Widget>[
  //                 Hero(
  //                     tag: 'Hero',
  //                     child: CircleAvatar(
  //                       child: Image.asset('assets/images/temp_logo.jpg'),
  //                       backgroundColor: Colors.transparent,
  //                       radius: 58.0,
  //                     )),
  //                 SizedBox(height: 45.0),
  //                 TextFormField(
  //                   controller: idController,
  //                   keyboardType: TextInputType.emailAddress,
  //                   decoration: InputDecoration(
  //                       hintText: '아이디', border: OutlineInputBorder()),
  //                 ),
  //                 SizedBox(height: 15.0),
  //                 TextFormField(
  //                   controller: passwordController,
  //                   keyboardType: TextInputType.visiblePassword,
  //                   obscureText: true,
  //                   decoration: InputDecoration(
  //                       hintText: '비밀번호', border: OutlineInputBorder()),
  //                 ),
  //                 SizedBox(width: 10.0),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                       backgroundColor: Color(0xff1160aa),
  //                       foregroundColor: Colors.white),
  //                   child: Text('로그인'),
  //                   onPressed: () {
  //                     getSQLData();
  //                   },
  //                 ),
  //                 SizedBox(width: 10.0),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                       backgroundColor: Color(0xff1160aa),
  //                       foregroundColor: Colors.white),
  //                   child: Text('회원가입'),
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => Sign_up()),
  //                     );
  //                   },
  //                 ),
  //                 SizedBox(width: 10.0),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                       backgroundColor: Color(0xff1160aa),
  //                       foregroundColor: Colors.white),
  //                   child: Text('기기등록'),
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => DevicePage()),
  //                     );
  //                   },
  //                 ),
  //                 SizedBox(width: 10.0),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                       backgroundColor: Color(0xff1160aa),
  //                       foregroundColor: Colors.white),
  //                   child: Text('회원정보'),
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => UserData()),
  //                     );
  //                   },
  //                 ),
  //                 //----------------------------
  //                 // SizedBox(width: 10.0),
  //                 // ElevatedButton(
  //                 //   style: ElevatedButton.styleFrom(
  //                 //       backgroundColor: Color(0xff1160aa),
  //                 //       foregroundColor: Colors.white),
  //                 //   child: Text('디바이스정보'),
  //                 //   onPressed: () {
  //                 //     Navigator.push(
  //                 //       context,
  //                 //       MaterialPageRoute(builder: (context) => DeviceData()),
  //                 //     );
  //                 //   },
  //                 // ),
  //                 // SizedBox(width: 10.0),
  //                 // ElevatedButton(
  //                 //   style: ElevatedButton.styleFrom(
  //                 //       backgroundColor: Color(0xff1160aa),
  //                 //       foregroundColor: Colors.white),
  //                 //   child: Text('날씨'),
  //                 //   onPressed: () {
  //                 //     Navigator.push(
  //                 //       context,
  //                 //       MaterialPageRoute(builder: (context) => HomeScreen()),
  //                 //     );
  //                 //   },
  //                 // ),
  //               ],
  //             )),
  //       ),
  //     );
  //     }
  //   );
  // }
}
