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
              return Card(
                  child: Container(
                      child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      data[index].status.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data[index].datetime.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    leading: Text(
                      data[index].sensor.toString(),
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
