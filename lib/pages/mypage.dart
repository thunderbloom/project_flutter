import 'package:flutter/material.dart';

class MyPage4 extends StatefulWidget {
  MyPage4({Key? key}) : super(key: key);

  @override
  State<MyPage4> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원정보 수정"),
        backgroundColor: Color(0xff1160aa),
      ),
    );
  }
}
