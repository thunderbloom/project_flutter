import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryData extends StatefulWidget {
  const HistoryData({
    Key? key,
  }) : super(key: key);

  @override
  State<HistoryData> createState() => _HistoryDataState();
}

class _HistoryDataState extends State<HistoryData> {
  //------------------------------------------로그인 정보 가져오기---------------//
  String userinfo = '';
  String sensor = '';
  String status = '';
  String datetime = '';
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

  Future<List<History>> getSQLData() async {
    final List<History> historyList = [];
    final Mysql db = Mysql();
    await db.getConnection().then((conn) async {
      String sqlQuery =
          'select sensor, status, datetime from History where user_id="$userinfo" order by datetime DESC';
      await conn.query(sqlQuery).then((result) {
        for (var res in result) {
          final historyModel = History(
            sensor: res["sensor"],
            status: res["status"],
            datetime: res["datetime"],
          );
          historyList.add(historyModel);
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return historyList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "알림내역",
        ),
        centerTitle: true,
        backgroundColor: Color(0xff1160aa),
      ),
      body: Center(
        child: getDBData(),
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
              if (data[index].sensor.toString() == 'door') {
                sensor = '현관문';
              } else if (data[index].sensor.toString() == 'camera') {
                sensor = '카메라';
              } else {
                sensor = '베란다';
              }
              if (data[index].status.toString() == 'open') {
                status = '문열림';
              } else if (data[index].status.toString() == 'close') {
                status = '문닫힘';
              } else {
                status = '사람 접근 감지';
              }
              datetime = data[index].datetime.toString();
              String datetime1 = datetime.substring(0, datetime.length - 5);
              return Card(
                  child: Container(
                      child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      status,
                      //data[index].status.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      datetime1,
                      //data[index].datetime.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    leading: Text(
                      sensor,
                      //data[index].sensor.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              )));
              // return Padding(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: <Widget>[
              //         ListTile(
              //           title: Text(
              //             data[index].status.toString(),
              //             style: const TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           subtitle: Text(
              //             data[index].datetime.toString(),
              //             style: const TextStyle(fontSize: 20),
              //           ),
              //           leading: Text(
              //             data[index].sensor.toString(),
              //             style: const TextStyle(fontSize: 20),
              //           ),
              //         ),
              //       ],
              //     ));
              // return ListTile(
              //   leading: Text(
              //     data[index].sensor.toString(),
              //     style: const TextStyle(fontSize: 20),
              //   ),
              //   title: Text(
              //     data[index].status.toString(),
              //     style: const TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   subtitle: Text(
              //     data[index].datetime.toString(),
              //     style: const TextStyle(fontSize: 20),
              //   ),
              // );
            },
          );
        });
  }
}
