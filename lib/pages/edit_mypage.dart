import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/show_user_db.dart';

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
    // print('여기까진 잘 됨 $userinfo');

    try {
      setState(() {
        final String? userinfo = prefs.getString('id');
        print('여기까진 잘 됨 $userinfo');
      });
    } catch (e) {}
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();        

  void updateData() async {
    db.getConnection().then((conn) {
      String sqlQuery =
          'update User set name=?, phone_number=?, address=?, email=? where user_id=?';
      conn.query(sqlQuery, [
        nameController.text,
        phoneController.text,
        addressController.text,
        emailController.text,
        userinfo
      ]);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("수정 완료."),
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
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '회원 정보 수정',
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
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '이름',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '다시 입력해주세요';
                          }
                          return null;
                        }),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '전화번호',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '다시 입력해주세요';
                          }
                          return null;
                        }),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                        controller: addressController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '주소',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '다시 입력해주세요';
                          }
                          return null;
                        }),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: '이메일',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '다시 입력해주세요';
                          }
                          return null;
                        }),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    child: Text('수정'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        toast(context, "기기등록 완료!");
                        updateData();
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