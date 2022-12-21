import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/data_table.dart';

class DeviceData extends StatefulWidget {
  const DeviceData({
    Key? key,
  }) : super(key: key);

  @override
  State<DeviceData> createState() => _DeviceDataState();
}

class _DeviceDataState extends State<DeviceData> {
  Future<List<Devices>> getSQLData() async {
    final List<Devices> deviceList = [];
    final Mysql db = Mysql();
    await db.getConnection().then((conn) async {
      String sqlQuery =
          'select user_id, serial_number, device_Name from Device';
      await conn.query(sqlQuery).then((result) {
        for (var res in result) {
          final deviceModel = Devices(
            user_id: res["user_id"],
            serial_number: res["serial_number"],
            device_name: res["device_name"],
            //Device_Name: res["Device_Name"],
          );
          deviceList.add(deviceModel);
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return deviceList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device')),
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
              return ListTile(
                leading: Text(
                  data[index].user_id.toString(),
                  style: const TextStyle(fontSize: 25),
                ),
                title: Text(
                  data[index].serial_Number.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  data[index].device_name.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              );
            },
          );
        });
  }
}
