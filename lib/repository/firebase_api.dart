import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart' as UserApp;
import '../models/negocios.dart' as NegociosApp;

class FirebaseApi {

  Future<String?> createUser(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException ${e.code}");
      return e.code;
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.code}");
      return e.code;
    }
  }

  Future<String?> signInUser(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException ${e.code}");
      return e.code;
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.code}");
      return e.code;
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void recoveryPassword(String emailAdress) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAdress);
  }

  Future<bool> validateSession() async {
    return await FirebaseAuth.instance.currentUser == null;
  }

  Future<String> createUserInDB(UserApp.User user) async {
    try {
      var db = FirebaseFirestore.instance;
      final document = await db
          .collection('usuarios')
          .doc(user.uid)
          .set(user.toJson());
      return user.uid;
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.message}");
      return e.code;
    }
  }

  Future<String> createNegocioInDB(NegociosApp.negocios negocio) async {
    try {
      var db = FirebaseFirestore.instance;
      final usuarioID = FirebaseAuth.instance.currentUser?.uid;
      final NegocioID = await db
          .collection('negocio')
          .doc();
      negocio.nid = NegocioID.id;
      negocio.uid= usuarioID;
      final userRef = db.collection("usuarios").doc(usuarioID).update({
        "LNegocios": FieldValue.arrayUnion([negocio.nid])
      });
      final document = await NegocioID.set(negocio.toJson());
      return negocio.nid;
    } on FirebaseException catch (e) {
      print("FirebaseException ${e.message}");
      return e.code;
    }
  }
}