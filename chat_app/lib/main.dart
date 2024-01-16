import 'package:camera/camera.dart';
import 'package:chat_app/NewScreen/LandingScreen.dart';
import 'package:chat_app/screens/CameraScreen.dart';
import 'package:chat_app/screens/HomeScreen.dart';
import 'package:chat_app/screens/LoginScreen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "OpenSans",
        primaryColor: Color(0xFF075E54),
        hintColor: Color(0xFF128C7E),
      ),
      home: LoginScreen (),
    );
  }
}
