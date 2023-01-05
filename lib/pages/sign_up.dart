import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';
import 'package:mysql_client/mysql_protocol.dart';
import 'package:crypto/src/sha256.dart' as sha;
import 'package:mysql_client/src/mysql_protocol/mysql_packet.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:project_flutter/pages/signup_after.dart';

void main() => runApp(Sign_up(
      title: 'sign up',
    ));

class Sign_up extends StatefulWidget {
  const Sign_up({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  final db = Mysql();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController(); //ID
  final TextEditingController passwordController1 =
      TextEditingController(); // password1
  final TextEditingController nameController = TextEditingController(); // name
  final TextEditingController phonenumberController =
      TextEditingController(); // phone number
  final TextEditingController addressController =
      TextEditingController(); // adress
  final TextEditingController emailController = TextEditingController(); //email

  Digest encrypt() {
    var bytes = utf8.encode('${passwordController1.text}');

    Digest sha256Result = sha.sha256.convert(bytes);

    return sha256Result;
  }

  // bool _isValidPhone(String val) {
  //   return RegExp(r'^010\{7,8}$').hasMatch(val);
  // }

  // bool _isValidPassword(String val) {
  //   return RegExp(r'^[a-zA-z0-9]{4,8}$').hasMatch(val);
  // }

  void insertData() async {
    Digest encrpyted_password = encrypt();
    db.getConnection().then((conn) {
      String sqlQuery =
          'INSERT into User (user_id, password, name, phone_number, address, email) values (?, ?, ?, ?, ?, ?)';
      conn.query(sqlQuery, [
        idController.text,
        encrpyted_password.toString(),
        nameController.text,
        phonenumberController.text,
        addressController.text,
        emailController.text
      ]);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("회원가입되었습니다."),
          duration: Duration(milliseconds: 700),
        ));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    idController.dispose();
    passwordController1.dispose();
    nameController.dispose();
    phonenumberController.dispose();
    addressController.dispose();
    emailController.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('정말로 나가시겠습니까?'),
            content: new Text('뒤로가기를 원하시면 확인을 클릭하세요'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
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
        appBar: AppBar(
          backgroundColor: Color(0xff1160aa),
          title: Text('회원가입'),
          centerTitle: true,
          // elevation: 0,
          // title: Column(
          //   children: <Widget>[
          //     Center(
          //       child: Text(
          //         '회원가입',
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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            hintText: '아이디',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '다시 입력해주세요';
                            } else if (value.length < 4) {
                              return '글자수가 너무 적습니다. 4자리 이상 아이디를 입력하세요.';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '이메일',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                          } else if (!value.contains("@") ||
                              !value.contains(".")) {
                            return "유효한 이메일을 입력해주세요";
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '비밀번호',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
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
                          obscureText: true,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            hintText: '비밀번호 확인',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 한번 더 입력하세요';
                            } else if (value.length < 8) {
                              return '8자 이상 입력하세요.';
                            } else if (value != passwordController1.text) {
                              return '비밀번호가 일치하지 않습니다.';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '이름',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
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
                          controller: phonenumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            hintText: '휴대폰 번호',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return '휴대폰 번호를 입력해주세요';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: TextFormField(
                        controller: addressController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '주소',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '주소를 입력해주세요';
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
                        child: Text('회원가입'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('회원가입 완료!'),
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
                                            toast(context, "회원가입 완료!");
                                            insertData();
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
        ),
      ),
    );
  }

  void toast(BuildContext context, String s) {}
}
