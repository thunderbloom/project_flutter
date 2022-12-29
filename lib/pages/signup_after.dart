import 'package:flutter/material.dart';
import 'package:project_flutter/main.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/pages/main_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/data_table.dart';

void main() => runApp(Signup_after());


class Signup_after extends StatefulWidget {
  const Signup_after({Key? key}) : super(key: key);
  @override
  _Signup_afterState createState() => _Signup_afterState();
}
class _Signup_afterState extends State<Signup_after> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
           backgroundColor: Color(0xff1160aa),
          elevation: 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  '회원가입 완료',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.7,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Nanum Barumpen',
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/temp_logo.jpg', // png 바꾸기
                width: 150.0,
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 8),
              child: Text(
                "회원가입이 완료되었습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff1160aa),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Text(
                '  님의 회원가입을 축하합니다.   ' // 이름 보이게 연동 할 것
                '스마트 홈을 이용하실수 있는 '
                '아이디는 입니다.',         // 아이디 보이게 연동 할 것
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.white),
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: const BorderSide(color: Color(0xff1160aa)),
                  ),
                ),
                child: const Text(
                  '시작하기',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            )
          ],
        ));
  }
}
