import 'package:flutter/material.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/new_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final idController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    idController.dispose();
    super.dispose();
  }

  Future<List<Profiles>> authenticate() async {
    final List<Profiles> profileList = [];
    final Mysql db = Mysql();
    await db.getConnection().then((conn) async {
      String test1 = idController.text.toString(); // id
      String test2 = emailController.text.toString(); // email

      await conn
          .query("SELECT Email FROM User WHERE ID = '${idController.text}'") // email 
          .then((result) {
        // email
        String pass = result.toString(); // email
        String test_pass = idController.text.toString(); // email
        print("email" + test_pass);

        if (test2 == test_pass) {
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              '아이디를 입력 해 주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: idController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'ID',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              '이메일 주소를 입력해 주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Email address',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              authenticate();
            },
            child: Text('인증하기'),
            color: Colors.deepPurple[200],
          )
        ],
      ),
    );
  }
}
