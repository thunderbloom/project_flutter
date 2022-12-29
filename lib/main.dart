import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_flutter/pages/login_page.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:project_flutter/mqtt/mqtt_client_connect.dart';
import 'package:project_flutter/pages/main_page.dart';
import 'package:project_flutter/pages/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // runApp(MyApp());
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

// Future<void> main() async{
//   // Step 3. Initialization
//   WidgetsFlutterBinding.ensureInitialized();
//   NotificationService notificationService = NotificationService();
//   await notificationService.init();

//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? const Loding() : const LoginPage(),);
        // home: const LoginPage());
  }
}