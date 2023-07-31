import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tyre_life_app/screens/home_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tyre Life', 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/':(context) =>const HomeScreen(),
      //   '/takePicture': (context) => TakePictureScreen(camera: camera),
      //   '/displayPicture': (context) => const DisplayPictureScreen(imagePath: 'imagePath')
      // },
    );
  }
}