import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:project_flutter/pages/device_page.dart';
import 'package:project_flutter/pages/reset_pw_page.dart';
import 'package:project_flutter/pages/sign_up.dart';
import 'package:project_flutter/pages/show_device_db.dart';
import 'package:project_flutter/pages/show_user_db.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:crypto/src/sha256.dart' as sha;
import 'package:project_flutter/pages/main_page.dart';
import 'package:project_flutter/pages/sign_up.dart';
import 'package:project_flutter/views/home_screen.dart';
// import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:project_flutter/mqtt/mqtt_client_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_flutter/pages/notification_service.dart';

void main() => runApp(LoginPage());
// Future<void> main() async {
//       WidgetsFlutterBinding.ensureInitialized();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       bool? id = prefs.getBool("id");
//       // print("id:" + id.toString());
//       runApp(MaterialApp(home: id == null ? LoginPage() : Loding()));
//     }
String userinfo = '';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  //this.userinfo
  //final String? userinfo;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String useridinfo = '';
  //SharedPreferences _prefs;

  final db = Mysql();
  // late MqttClient client;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // late SharedPreferences logindata;
  // late bool newuser;
  // Future signIn() async {
  //   await db.getConnection().then((conn) async {
  //     await conn
  //         .query(
  //             "SELECT password FROM User WHERE user_id = '${idController.text}'")
  //         .then((password) {
  //       id:
  //       idController.text.toString();
  //       password:
  //       passwordController.text.toString();
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // check_if_already_login();
    getSQLData();
    
  }
  // String savedid = '';
  // String savedpw = '';
  // void check_if_already_login() async {
  //   logindata = await SharedPreferences.getInstance();
  //   newuser = (logindata.getBool('id') ?? true);
  //   print(newuser);
  //   if (newuser == false) {
  //     Navigator.pushReplacement(
  //         context, new MaterialPageRoute(builder: (context) => Loding()));
  //   } else{
  //     getSQLData();
      // Navigator.pushReplacement(
      //     context, new MaterialPageRoute(builder: (context) => getSQLData()));
  //   }
  // }



  Future<List<Profiles>> getSQLData() async {
    final List<Profiles> profileList = [];
    final Mysql db = Mysql();
    // late MqttClient client;
    final prefs = await SharedPreferences.getInstance();
    // await connect().then((value) {
    //                   client = value;
    //                 });
    // savedid = prefs.getString("id")!;
    // savedpw = prefs.getString("password")!;

    // if (savedid != null && savedpw != null){
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (BuildContext context) => Loding()));
    //           connect().then((value) {            
    //             client = value;});
    // } else {
    // await client.subscribe(topic, MqttQos.atLeastOnce);
    // NotificationService().init();
      await db.getConnection().then((conn) async {
        String test = idController.text.toString();

        await conn
            .query(
                "SELECT Password FROM User WHERE user_id = '${idController.text}'",
                )
            .then((result) {
          String pass = result.toString();
          String test_pass = passwordController.text.toString();
          String pw = pass.substring(20, pass.length - 2); // db에 저장된 비밀번호

          Digest decrpyted_password = decrypt(); //추가

          String pass_decrypt = decrpyted_password.toString(); // 추가
          String userid = idController.text;
          prefs.setString('id', userid);
          // prefs.setString('password', pw);
          prefs.setBool('isLoggedIn', true);
          final String? userinfo = prefs.getString('id');
          // setState((){});
          // prefs.setString('password', pw);
          //print('$useridinfo');
          

          
            
          if (pw == pass_decrypt) {
            print("패스워드 일치");
            // print(userinfo);
            // WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => Loding()));

            // connect().then((value) {
            //   // ------------------------MQTT 연결
            //   client = value;
             
            // });
            print(userinfo);
            // print("접속된 유저 id : $userid");
            // client.subscribe('$userid', MqttQos.atLeastOnce);

            // final userId = UserID(userid) ;

            // Get.to(UserID, arguments: userid);
            // var arg = Get.arguments;
            // Text('${Get.arguments}');
            // client.subscribe(topic, MqttQos.atLeastOnce);
            // client.subscribe(userid, MqttQos.atLeastOnce);

            // print('MQTT subscribed from Topic : ${idController.text}');
            // });
          } else
            setState(() {
              print("패스워드 불일치");
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("비밀번호가 틀립니다."),
                duration: Duration(milliseconds: 700),
              ));
            });
          
        }
        
        





        );
        setState(() {
          // final RxBool _isLoading = true.obs;
        });

        // await conn
        //     .query(
        //         'select ip from UserIp where user_id="$userinfo"')
        //     .then((result) {
        //   String ip = result.toString();          
        //   String userip = ip.substring(14, ip.length - 2);         
          
          
        //   prefs.setString('userip', userip);
        //   // prefs.setString('password', pw);
        //   print(userip);
        //   });
        // setState(() {          
        // });
      });
      // }
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
        tag: 'home', //CircleAvatar
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 90.0,
          child: Image.asset('assets/images/logo.png'),
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

      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return '아이디를 확인해주세요!';
      //   } else if (value.length < 4) {
      //     return '글자수가 너무 적습니다. 4자리 이상 아이디를 입력하세요.';
      //   }
      //   return null;
      // },
    );

    final password = TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscuringCharacter: "*",
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

      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return '비밀번호를 입력해주세요';
      //   } else if (value.length < 8) {
      //     return '8자 이상 입력하세요';
      //   }
      //   return null;
      // },
    );

    final loginButton = Padding(
        padding: EdgeInsets.all(20.0),
        child: GestureDetector(
          // onTap: signIn,
          child: MaterialButton(
            minWidth: 200.0,
            height: 48.0,
            onPressed: () {
              // if (_formKey.currentState!.validate()) {
              //final prefs = await SharedPreferences.getInstance();
              //prefs.setBool('isLoggedIn', true);
              getSQLData();
              // }
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
                  context,
                  MaterialPageRoute(
                      builder: (context) => Sign_up(
                            title: 'sign up',
                          )));
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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 24.0),
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
        ));
  }
}

class UserID {
  String user_id;

  UserID(this.user_id);
}
