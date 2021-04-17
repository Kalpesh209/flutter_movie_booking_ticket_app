import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie_ticket_booking_app/screens/home_page_screen.dart';

/*
Title: App Entry Point
Purpose:App Entry Point
Created By:Kalpesh Khandla
*/

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Open-Sans",
      ),
      home: HomePageScreen(),
    );
  }
}
