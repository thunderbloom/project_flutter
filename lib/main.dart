import 'package:flutter/material.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:project_flutter/mqtt/mqtt_client_connect.dart';
import 'package:project_flutter/pages/notification_service.dart';

// void main() {
//   runApp(const MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // 
   
  runApp(MyApp());
}
// Future<void> main() async{
//   // Step 3. Initialization
//   WidgetsFlutterBinding.ensureInitialized();
//   NotificationService notificationService = NotificationService();
//   await notificationService.init();

//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
