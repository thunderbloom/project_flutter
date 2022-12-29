import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:project_flutter/mqtt/mqtt_client_connect.dart';
//import 'package:project_flutter/mqtt/mqtt_client_connect.dart';

class MyMqttPage extends StatefulWidget {
  const MyMqttPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyMqttPageState createState() => _MyMqttPageState();
}

class _MyMqttPageState extends State<MyMqttPage> {
  late MqttClient client;
  var topic = "house/door";
  // GlobalKey : app에서 유일한 키 생성 ( 폼의 validation을 위해서)
  // final _formKey = GlobalKey<FormState>();

  // final _heightController = TextEditingController();
  // final _weightController = TextEditingController();

  // @override
  // void dispose() {    // 소멸자 : 콘트롤러는 반드시 해제
  //   _heightController.dispose();
  //   _weightController.dispose();
  //   super.dispose();
  // }

  // void _publish(String message) {
  //   final builder = MqttClientPayloadBuilder();
  //   builder.addString('Hello from flutter_client');
  //   client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  // }

  // void _publishBmi(String message) {
  //   final builder = MqttClientPayloadBuilder();
  //   var height = double.parse(_heightController.text.trim());
  //   var weight = double.parse(_weightController.text.trim());
  //   var bmi = weight / ((height / 100) * (height / 100));
  //   var data = "{\"height\": $height, \"weight\": $weight, \"bmi\": $bmi}";
  //   builder.addString(data);
  //   // builder.addString('height : $height weight: $weight bmi: $bmi');
  //   client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  // }

  void _publish(String message) {
    final builder = MqttClientPayloadBuilder();
    // builder.addString('Hello from flutter_client');
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Connect'),
              onPressed: () => {
                connect().then((value) {
                  client = value;
                })
              },
            ),
            ElevatedButton(
              child: Text('Subscribe'),
              onPressed: () {
                client.subscribe(topic, MqttQos.atLeastOnce);
              },
            ),
            ElevatedButton(
              child: const Text('Publish'),
              onPressed: () => {_publish('light_on')},
            ),
            ElevatedButton(
              child: const Text('Unsubscribe'),
              onPressed: () => {client.unsubscribe(topic)},
            ),
            ElevatedButton(
              child: const Text('Disconnect'),
              onPressed: () => {client.disconnect()},
            ),
            // 폼에 관련된 Widget
            // Form(
            //   key: _formKey,
            //   child : Column(
            //     children: <Widget>[   // 위젯 리스트를 전달
            //       TextFormField(
            //         decoration: const InputDecoration(
            //           border: OutlineInputBorder(),   // 박스 형태의 출력
            //           hintText: '키(cm)',
            //           ),
            //         controller: _heightController,
            //         keyboardType: TextInputType.number,
            //         validator: (value) {
            //           if (value!.trim().isEmpty) {     // 검증
            //             return '키를 입력해 주세요';
            //           }
            //           return null;
            //         },
            //       ),
            //       const SizedBox(   // form 간 공백을 만들기 위해서 입력
            //         height: 16.0,
            //       ),
            //       TextFormField(
            //         decoration: const InputDecoration(
            //           border: OutlineInputBorder(),
            //           hintText: '몸무게(kg)',
            //         ),
            //         controller: _weightController,
            //         keyboardType: TextInputType.number,
            //         validator: (value) {
            //           if (value!.trim().isEmpty) {
            //             return '몸무게를 입력해 주세요';
            //           }
            //           return null;
            //         },
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(top: 16.0),
            //         alignment: Alignment.centerRight,
            //         child: ElevatedButton(
            //           onPressed: () {
            //             if (_formKey.currentState!.validate()) {   //  폼에 키를 부여하고 준 validator를 한꺼번에 검증
            //               var heightTrim = double.parse(_heightController.text.trim());
            //               var weightTrim = double.parse(_weightController.text.trim());
            //               var bmi = weightTrim / ((heightTrim / 100) * (heightTrim / 100));
            //               _publish(
            //                 "{\"height\": $heightTrim, \"weight\": $weightTrim, \"bmi\": $bmi}"
            //               );
            //               Navigator.push( // 창 이동
            //                 context,
            //                 MaterialPageRoute(  // 생성되는 페이지로 이동
            //                   builder: (context) => BmiResult(
            //                     heightTrim,  // 더블로 캐스팅 된 숫자가 전달
            //                     weightTrim)
            //                 ),
            //               );
            //             }
            //             // _publishBmi('calculate bmi');
            //           },
            //           child: const Text('결과 및 전송')
            //         ),
            //       )
            //     ],
            //   )
            // ),
          ],
        ),
      ),
    );
  }
}

// class BmiResult extends StatelessWidget {
//   final double height;
//   final double weight;
//   BmiResult(this.height, this.weight);

//   @override
//   Widget build(BuildContext context) {
//     final bmi = weight / ((height / 100) * (height / 100));
//     debugPrint('bmi : $bmi');
//     return Scaffold(
//       appBar: AppBar(title: const Text('비만도 계산기')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget> [
//             Text(
//               _calcBmi(bmi),  // 텍스트 결과
//               style: TextStyle(fontSize: 36),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             _buildIcon(bmi),  // 아이콘 결과
//           ]
//         ),
//       )
//     );
//   }
//   String _calcBmi(double bmi) {
//     var result = '저체중';
//     if (bmi >=35) {
//       result = '고도 비만';
//     } else if (bmi >= 30) {
//       result = '2단계 비만';
//     } else if (bmi >= 25) {
//       result = '1단계 비만';
//     } else if (bmi >= 23) {
//       result = '과체중';
//     } else if (bmi >= 18.5) {
//       result = '정상';
//     }
//     return result;
//   }
//   Widget _buildIcon(double bmi) {
//     if (bmi >= 23) {
//       return const Icon(
//         Icons.sentiment_very_dissatisfied,
//         color: Colors.red,
//         size: 100,
//       );
//     } else if (bmi >= 18.5) {
//       return const Icon(
//         Icons.sentiment_satisfied,
//         color: Colors.green,
//         size: 100,
//       );
//     } else {
//       return Icon(
//         Icons.sentiment_dissatisfied,
//         color: Colors.orange,
//         size: 100,
//       );
//     }
//   }
// }
