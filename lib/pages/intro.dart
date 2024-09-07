import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/pages/home.dart';

// ignore: camel_case_types
class intro extends StatefulWidget {
  const intro({super.key});

  @override
  State<intro> createState() => _introState();
}

// ignore: camel_case_types
class _introState extends State<intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: 200,
        splash: Image.asset(
          "assets/images/logo.png",
          height: 1000,
          width: 1000,
        ),
        nextScreen: const Home(),
        splashTransition: SplashTransition.rotationTransition,
        duration: 13,
      ),
    );
  }
}
