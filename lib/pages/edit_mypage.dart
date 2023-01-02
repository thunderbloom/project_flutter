import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/sha256.dart' as sha;

import 'package:flutter/material.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMyPage extends StatefulWidget {
  const EditMyPage({Key? key}) : super(key: key);

  @override
  State<EditMyPage> createState() =>_EditMyPage();
}

class _EditMyPage extends State<EditMyPage> {
  final db = Mysql();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userinfo = prefs.getString('id')!;
    });

    try {
      setState(() {
        final String? userinfo = prefs.getString('id');
        print('확인 $userinfo');
      });
    } catch (e) {}
  }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();        

  Digest encrypt() {
    var bytes = utf8.encode(passwordController.text);
    Digest sha256Result = sha.sha256.convert(bytes);
    return sha256Result;
  }
  void updateData() async {
    Digest encrpytedPassword = encrypt();
    db.getConnection().then((conn) {
      String sqlQuery =
          'update User set password=?, phone_number=?, address=?, email=? where user_id=?';
      conn.query(sqlQuery, [
        encrpytedPassword.toString(),
        phoneController.text,
        addressController.text,
        emailController.text,
        userinfo
      ]);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("정보를 수정했습니다."),
          duration: Duration(milliseconds: 700),
        ));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
// AppBar
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff1160aa),
        centerTitle: true, // 중앙 정렬                 
        title: const Text(
          '회원정보 수정', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,            
          ),
        ),
      ),
// Body        
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
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                        hintText: '비밀번호',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '다시 입력해주세요';
                        } else if(value.length < 8) {
                          return '글자수가 너무 적습니다. 8자리 이상 입력하세요.';
                        }
                        return null;
                      }
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      obscuringCharacter: "*",                      
                      decoration: InputDecoration(
                        hintText: '비밀번호 확인',
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '다시 입력해주세요';
                        } else if (value.length < 8) {
                          return '글자수가 너무 적습니다. 8자리 이상 입력하세요.';
                        } else if (value != passwordController.text) {
                          return '비밀번호가 일치하지 않습니다.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                        hintText: '전화번호',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '다시 입력해주세요';
                        }
                        return null;
                      }
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                        hintText: '주소',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '다시 입력해주세요';
                        }
                        return null;
                      }
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                        hintText: '이메일',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '다시 입력해주세요';
                        } else if(!value.contains("@") || !value.contains(".")) {
                          return "유효한 이메일을 입력해주세요";
                        }
                        return null;
                      }
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    child: Text('저장'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        toast(context, "수정 완료!");
                        updateData();
                        print(userinfo);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ),
      )
    );
  }

  void toast(BuildContext context, String s) {}
}