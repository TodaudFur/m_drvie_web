import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_drvie_web/drive_detail/drive_detail.dart';
import 'package:m_drvie_web/login.dart';
import 'package:m_drvie_web/mdrive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '엠마오 드라이브',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LoginPage()),
        GetPage(name: '/drive', page: () => MDrive()),
        GetPage(name: '/driveDetail', page: () => DriveDetail()),
      ],
    );
  }
}
