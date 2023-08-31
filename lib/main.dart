import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tracker/settings.dart';
import 'package:tracker/traking_page.dart';
import 'package:tracker/bluetoothpage.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/animation_ll7icbzo.json'),
      nextScreen: const Home(),
      splashIconSize: 300,
      duration: 3000,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final items = const [
    Icon(Icons.location_history, color: Colors.deepPurpleAccent, size: 30),
    Icon(Icons.add_location_alt_outlined, color: Colors.red, size: 30),
    Icon(Icons.list_outlined, color: Colors.orange, size: 30),
  ];
  int index = 1;

  Widget getselectedWidget({required int index}) {
    Widget widget = const TrackingPage();
    switch (index) {
      case 0:
        widget = const BluetoothPage();
        break;
      case 1:
        widget = const TrackingPage();
        break;
      case 2:
        widget = const ProfileScreen();
        break;
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime Tracking',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          items: items,
          index: index,
          height: 70,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: const Color.fromARGB(127, 255, 255, 255),
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.linearToEaseOut,
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: getselectedWidget(index: index),
        ),
      ),
    );
  }
}
