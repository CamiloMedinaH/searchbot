import 'package:flutter/material.dart';
import 'package:searchbot/pages/home_navigation_bar_page.dart';
import 'package:searchbot/pages/recovery_password.dart';
import 'package:searchbot/pages/sign_up_page.dart';

import '../repository/firebase_api.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final FirebaseApi _firebaseApi = FirebaseApi();

  bool _isPasswordObscure = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
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
                  TextFormField(
                    controller: _password,
                    obscureText: _isPasswordObscure,
                    decoration:  InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscure = !_isPasswordObscure;
                            });
                          },
                        ),
                        labelText: "Contraseña"),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: _onSignInButtonClicked,
                    child: const Text("Iniciar sesion"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()
                        ),
                      );
                    },
                    child:const Text("Registrarse"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecoveryPassword()
                        ),
                      );
                    },
                    child:const Text("Olvidaste tu constraseña?"),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  void _onSignInButtonClicked() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      showMsg("Debe digitar todos los campos");
    } else {
      var result = await _firebaseApi.signInUser(_email.text, _password.text);
      if (result == 'invalid-credential') {
        showMsg('Correo electronico o contraseña incorrecta');
      } else if (result == 'invalid-email') {
        showMsg('Él correo electronico esta mal escrito');
      } else if (result == 'network-request-failed') {
        showMsg('Revise su conexion a internet');
      } else {
        showMsg('Bienvenido');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeNavigationBarPage()),
        );
      }
    }
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


