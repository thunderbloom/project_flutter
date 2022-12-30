import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:project_flutter/pages/main_page.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';
import 'package:mysql_client/mysql_protocol.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:project_flutter/pages/login_page.dart';

void main() => runApp(Device_re(
      title: 'device_re',
    ));

class Device_re extends StatefulWidget {
  const Device_re({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _Device_regis createState() => _Device_regis();
}

class _Device_regis extends State<Device_re> {
  final db = Mysql();
  final _formKey = GlobalKey<FormState>();
  String userinfo = '';

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
      });
    } catch (e) {}
  }

  //final TextEditingController useridController = TextEditingController();
  //final TextEditingController userinfo = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController dnameController = TextEditingController();
//user_id,
  void insertData() async {
    db.getConnection().then((conn) {
      String sqlQuery =
          'INSERT into Device (user_id,serial_number, device_name) values ( ?,? , ?)';
      conn.query(sqlQuery, [
        //useridController.text,
        userinfo,
        serialController.text,
        dnameController.text,
      ]);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("기기등록 완료."),
          duration: Duration(milliseconds: 700),
        ));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    //useridController.dispose();
    //userinfo.dispose();
    serialController.dispose();
    dnameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '기기등록',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          centerTitle: true, // 중앙 정렬
          elevation: 0.0,
          backgroundColor: Color(0xff1160aa),
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
                  //  SizedBox(
                  //    height: 15.0,
                  //  ),
                  //  Padding(
                  //    padding: EdgeInsets.only(top: 8, bottom: 4),
                  //    child: TextFormField(
                  //        controller: useridController,
                  //        keyboardType: TextInputType.name,
                  //        decoration: InputDecoration(
                  //          contentPadding:
                  //              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //          border: OutlineInputBorder(
                  //              borderRadius: BorderRadius.circular(32.0)),
                  //          hintText: 'userid',
                  //        ),
                  //        validator: (value) {
                  //          if (value == null || value.isEmpty) {
                  //            return '다시 입력해주세요';
                  //          }
                  //          return null;
                  //        }),
                  //  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                        controller: serialController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '기기번호',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '다시 입력해주세요';
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
                        controller: dnameController,
                        //keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '기기이름',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '다시 입력해주세요';
                          }
                          return null;
                        }),
                  ),
                  ElevatedButton(
                    child: Text('기기등록'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        toast(context, "기기등록 완료!");
                        insertData();
                        print(userinfo);
                        // print(userinfo);
                        //Navigator.push(context,
                        //    MaterialPageRoute(builder: (context) => Loding()));
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
        ));
  }

  void toast(BuildContext context, String s) {}
}
