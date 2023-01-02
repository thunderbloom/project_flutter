import 'dart:convert'; // json 변환

import 'package:flutter/material.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:http/http.dart' as http;

class HistoryProvider with ChangeNotifier { // 변화가 있을 때 통지
  List<History> _items = [];
  final url = 'http:34.64.233.244:9898/histories'; // 서버측에서 REST방식 - json

  List<History> get items { // HistoryProvider properties : get함수를 이용해서 외부에서 접근
    return [..._items];
  }

  Future<void> addHistory(String jdk) async {
    if (jdk.isEmpty) {
      return;
    }
    Map<String, dynamic> request = {'user_id': jdk};
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse(url), // CRUD에 대한 정의가 서버측에 있어야 함 
    headers: headers, body: json.encode(request));
    Map<String, dynamic> responsePayload = json.decode(response.body);

    final history = History(
      idx: responsePayload["idx"],
      user_id: responsePayload["user_id"],
      sensor: responsePayload["sensor"],
      status: responsePayload["status"],
      datetime: responsePayload["datetime"]
    );
    _items.add(history);
    notifyListeners();
  }

  Future<void> get getHistory async {
    var response;
    try {
      response = await http.get(Uri.parse(url)); // json으로 리턴
      List<dynamic> body = json.decode(response.body);
      _items = body.map((e) => History(
          idx: e["idx"], user_id: e["user_id"], sensor: e["sensor"], status: e["status"], datetime: e["datetime"]
      )).toList();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> deleteHistory(int historyIdx) async {
    var response;
    try {
      response = await http.delete(Uri.parse("$url/$historyIdx"));
      final body = json.decode(response.body);
      _items.removeWhere((e) => e.idx == body["idx"]);
    } catch(e) {
      print(e);
      }
    notifyListeners();
  }

  Future<void> executeTask(int historyIdx) async {
    try{
      final response = await http.patch(Uri.parse("$url/$historyIdx"));
      Map<String, dynamic> responsePayload = json.decode(response.body);
      _items.forEach((e) => {
        if (e.idx == responsePayload["idx"]) {
          e.user_id = responsePayload["user_id"]
        }
      });
    } catch (e) {
      print(e);
      }
    notifyListeners();
  }
}