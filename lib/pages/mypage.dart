import 'package:flutter/material.dart';
import '../pages/show_user_db.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원정보"),
        backgroundColor: Color(0xff1160aa),
      ),
      body: UserData(
      ),

    );
  }
}
