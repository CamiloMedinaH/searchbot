import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchbot/pages/home_navigation_bar_page.dart';
import 'package:searchbot/pages/sign_in_page.dart';
import 'package:searchbot/pages/sign_up_page.dart';
import 'package:searchbot/repository/firebase_api.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  void initState() {
    _closeSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(image: AssetImage("assets/images/logo.png"),
        width: 400,
        height: 400,
        ),
      ),
    );
  }

  Future<void> _closeSplash() async {
    Future.delayed(const Duration(seconds: 4), () async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      var result = _firebaseApi.validateSession();
      if (await result) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeNavigationBarPage(uid:uid))
        );
      }
    });
  }
}
