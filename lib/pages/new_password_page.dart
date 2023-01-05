import 'package:flutter/material.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:crypto/src/sha256.dart' as sha;
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:project_flutter/pages/reset_pw_page.dart';

class PassWordReset extends StatefulWidget {
  const PassWordReset({Key? key}) : super(key: key);

  @override
  State<PassWordReset> createState() => _PassWordResetState();
}

class _PassWordResetState extends State<PassWordReset> {
  final db = Mysql();
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final passwordController1 = TextEditingController();

  Digest encrypt() {
    var bytes = utf8.encode('${passwordController1.text}');

    Digest sha256Result = sha.sha256.convert(bytes);

    return sha256Result;
  }

  void passwordUpdate() async {
    Digest encrpyted_password = encrypt();
    db.getConnection().then((conn) {
      String sqlQuery =
          "UPDATE User SET password = (?) WHERE user_id = '${idController.text}'";
      conn.query(sqlQuery, [
        encrpyted_password.toString(),
      ]);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("비밀번호가 변경되었습니다."),
          duration: Duration(milliseconds: 700),
        ));
      });
    });
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController1.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('정말로 나가시겠습니까?'),
            content: new Text('나가기를 원하시면 확인을 클릭하세요'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage())),
                child: new Text('확인'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('취소'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xff1160aa),
            title: Text('비밀번호 변경'),
            centerTitle: true,
            // elevation: 0,
            // title: Column(
            //   children: <Widget>[
            //     Center(
            //       child: Text(
            //         '비밀번호 변경',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           height: 1.7,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 25,
            //           fontFamily: 'Nanum Barumpen',
            //           fontStyle: FontStyle.normal,
            //         ),
            //       ),
            //     )
            //   ],
            // ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: TextFormField(
                        controller: idController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: '아이디',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '다시 입력해주세요';
                          } else if (value.length < 4) {
                            return '글자수가 너무 적습니다. 4자리 이상 아이디를 입력하세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: TextFormField(
                        controller: passwordController1,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                            hintText: '비밀번호',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          } else if (value.length < 8) {
                            return '8자 이상 입력하세요';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            hintText: '비밀번호 확인',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 한번 더 입력하세요';
                          } else if (value.length < 8) {
                            return '8자 이상 입력하세요.';
                          } else if (value != passwordController1.text) {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 50,
                      width: 370,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff1160aa), // Background color
                        ),
                        child: Text('비밀번호 변경'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('비밀번호 변경 완료!'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('로그인 페이지로 이동하시겠습니까?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('확인'),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            toast(context, "비밀번호 변경!");
                                            passwordUpdate();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()));
                                          }
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void toast(BuildContext context, String s) {}
}
