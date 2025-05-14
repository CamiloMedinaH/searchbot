import 'package:flutter/material.dart';
import 'package:searchbot/repository/firebase_api.dart';

class RecoveryPassword extends StatefulWidget {
  const RecoveryPassword({super.key});

  @override
  State<RecoveryPassword> createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends State<RecoveryPassword> {

  final _email = TextEditingController();

  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        labelText: "Correo electronico"),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_email.text.isEmpty) {
                        showMsg('Debe digitar un correo electronico');
                      } else {
                        _firebaseApi.recoveryPassword(_email.text);
                        showMsg('Revise su correo electronico');
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Recuperar contraseña"),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  void showMsg(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
        SnackBar(content: Text(msg),
            duration: Duration(seconds: 10),
            action: SnackBarAction(
                label: "Aceptar",
                onPressed: scaffold.hideCurrentSnackBar))
    );
  }

}