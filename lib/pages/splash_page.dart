import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:searchbot/pages/home_navigation_bar_page.dart';
import 'package:searchbot/pages/mapapage.dart';
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
  late LatLng posicionActual = LatLng(5, 10);

  @override
  void initState() {
    obtenerUbicacion();
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
          MaterialPageRoute(builder: (context) => Mapapage(posicionActual)),
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Mapapage(posicionActual))
        );
      }
    });
  }

  Future<void> obtenerUbicacion() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      return; // Debes pedir al usuario que habilite la ubicación.
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return; // El usuario denegó el permiso.
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      return; // El usuario bloqueó los permisos.
    }

    Position posicion = await Geolocator.getCurrentPosition();
    setState(() {
      posicionActual = LatLng(posicion.latitude, posicion.longitude);
    });
    print(posicionActual);
  }
}


