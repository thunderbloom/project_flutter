import 'package:flutter/material.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/new_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final db = Mysql();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final idController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    idController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('정말로 나가시겠습니까?'),
            content: new Text('뒤로가기를 원하시면 확인을 클릭하세요'),
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

  Future<List<Profiles>> authenticate() async {
    final List<Profiles> profileList = [];
    final Mysql db = Mysql();
    await db.getConnection().then((conn) async {
      String test2 = emailController.text.toString(); // email
      await conn
          .query(
              "SELECT email FROM User WHERE user_id = '${idController.text}'") // email
          .then((result) {
        String pass = result.toString(); // email

        String email = pass.substring(17, pass.length - 2);
        if (test2 == email) {
          print("회원 정보 일치");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PassWordReset())); //
        } else
          setState(() {
            print("회원정보 불일치");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("회원정보가 틀립니다."),
              duration: Duration(milliseconds: 700),
            ));
          });
      });
      setState(() {});
    });
    return profileList;
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
            title: Text('비밀번호 찾기'),
            centerTitle: true,
            // elevation: 0,
            // title: Column(
            //   children: <Widget>[
            //     Center(
            //       child: Text(
            //         '비밀번호 찾기',
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: '이메일',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
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
                    SizedBox(
                      height: 50,
                      width: 370,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff1160aa), // Background color
                        ),
                        child: Text('비밀번호 찾기'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('알림'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('비밀번호를 변경하시겠습니까?'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('확인'),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            toast(context, "비밀번호 찾기 완료!");
                                            authenticate();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PassWordReset()));
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
