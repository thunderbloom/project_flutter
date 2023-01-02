import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/sha256.dart' as sha;

import 'package:flutter/material.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/pages/main_page.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/show_user_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPage();
}

class _PasswordPage extends State<PasswordPage> {
  final db = Mysql();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

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

  Digest encrypt() {
    var bytes = utf8.encode(passwordController.text);
    Digest sha256Result = sha.sha256.convert(bytes);
    return sha256Result;
  }

  void updatePassword() async {
    Digest encrpytedPassword = encrypt();
    db.getConnection().then((conn) {
      String sqlQuery = 'update User set password=? where user_id=?';
      conn.query(sqlQuery, [
        encrpytedPassword.toString(),
        userinfo
      ]);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('정보를 수정했습니다.'),
          duration: Duration(milliseconds: 700),
        ));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff1160aa),
        centerTitle: true,
        title: const Text(
          '비밀번호', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
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
                  height: 30.0,
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
                      hintText: '비밀번호(8자리 이상)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '다시 입력해주세요';
                      } else if (value.length <8) {
                        return '글자수가 너무 적습니다. 8자리 이상 입력하세요.';
                      }
                      return null;
                    },
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
                      hintText: '비밀번호 재입력',
                      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '다시 입력해주세요';
                      } else if (value.length <8) {
                        return '글자수가 너무 적습니다. 8자리 이상 입력하세요.';
                      } else if (value != passwordController.text) {
                        return '비밀번호가 일치하지 않습니다.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  child: Text('확인'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      toast(context, "수정 완료!");
                      updatePassword();
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

    void toast(BuildContext context, String s) {}
}