import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoData extends StatefulWidget {
  const VideoData({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoData> createState() => _VideoDataState();
}

class _VideoDataState extends State<VideoData> {

  //------------------------------------------로그인 정보 가져오기---------------//
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
  //-----------------------------------------------------------------여기까지---------------------

  Future<List<Video>> getSQLData() async {
    final List<Video> videoList = [];
    final Mysql db = Mysql();
    await db.getConnection().then((conn) async {
      String sqlQuery = 'select file_name, Datetime from Video where user_id="$userinfo" order by datetime DESC';
      await conn.query(sqlQuery).then((result) {
        for (var res in result) {
          final videoModel = Video(
            // id: res["id"],
            file_name: res["file_name"],
            // Datetime: res["Datetime"],
          );
          videoList.add(videoModel);
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return videoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("video")),
      body: Center(
        child: getDBData(),
        //
      ),
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
              return ListTile(
                leading: Text(
                  data[index].file_name.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                //title: Text(
                //  data[index].Datetime.toString(),
                //  style: const TextStyle(
                //    fontSize: 20,
                //    fontWeight: FontWeight.bold,
                //  ),
                //),
                //subtitle: Text(
                //  data[index].Datetime.toString(),
                //  style: const TextStyle(fontSize: 20),
                //),
              );
            },
          );
        });
  }
}
