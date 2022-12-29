import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_flutter/pages/edit_mypage.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends StatefulWidget {
  const UserData({
    Key? key,
  }) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  
    String userinfo = '';
  // String userid = '';

  
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

  Future<List<Profiles>> getSQLData() async {
    final List<Profiles> profileList = [];
    final Mysql db = Mysql();
    await db.getConnection().then((conn) async {
      String sqlQuery =
          'select user_id, phone_number, address, email from User where user_id = "$userinfo"';
      await conn.query(sqlQuery).then((result) {
        for (var res in result) {
          final profileModel = Profiles(
              user_id: res["user_id"],
              phonenumber: res["phone_number"],
              address: res["address"],
              email: res["email"]);
          profileList.add(profileModel);
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return profileList;
  }
   //String? a=data[index].name.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getDBData(),
      // SafeArea(
      //   //mainAxisAlignment: MainAxisAlignment.center,
      //   child: Padding(padding:EdgeInsets.symmetric(),
      //   child:Column(mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     getDBData(),//SizedBox(child: getDBData(),), //getDBData(),
      //   SizedBox(height: 15,),
      //   SizedBox(child: CupertinoButton(child: Text('회원정보'), onPressed: (){}),)
      //   ],),//children:[
      //   // Container(child: getDBData(),), //getDBData(),
      //   // SizedBox(height: 15,),
      //   // SizedBox(child: CupertinoButton(child: Text('회원정보'), onPressed: (){}),)
      //   //]
      //   )//getDBData(),
      
      // ),
    );
  }

  FutureBuilder<List> getDBData() {
    return FutureBuilder<List>(
      future: getSQLData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final data = snapshot.data as List;
            return Card(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('계정 정보', style: TextStyle(color: Colors.grey)),
                    ListTile(
                      title: Text('아이디'),
                      subtitle: Text(data[index].user_id.toString()),
                      leading: Icon(Icons.people),
                    ),
                    ListTile(
                      title: Text('전화번호'),
                      subtitle: Text(data[index].phonenumber.toString()),
                      leading: Icon(Icons.phone),
                    ),
                    ListTile(
                      title: Text('주소'),
                      subtitle: Text(data[index].address.toString()),
                      leading: Icon(Icons.location_on),
                    ),
                    ListTile(
                      title: Text('이메일'),
                      subtitle: Text(data[index].email.toString()),
                      leading: Icon(Icons.email),
                    ),    
                    Divider(),
                    SizedBox(height: 285),
                    SizedBox(child:CupertinoButton(child: Text('회원정보'), onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => const EditMyPage()
                        )
                      );
                    }),)
                  ],
                )
              )
            );
          },
        );
      }
    );
  }
}
