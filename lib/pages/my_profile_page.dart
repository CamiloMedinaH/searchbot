import 'package:flutter/material.dart';
import 'package:searchbot/pages/sign_in_page.dart';
import 'package:searchbot/repository/firebase_api.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('MyProfile'),
                      ElevatedButton(
                          onPressed: _onSignOutButtonClicked,
                          child: const Text('Cerrar sesion')
                      )
                    ],
                  )
              )
          ),
        )
    );
  }

  void _onSignOutButtonClicked() {
    _firebaseApi.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

}
