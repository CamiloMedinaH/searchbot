import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:searchbot/repository/firebase_api.dart';
import 'package:searchbot/models/negocios.dart';

class NuevoNegocio extends StatefulWidget {
  const NuevoNegocio({super.key});

  @override
  State<NuevoNegocio> createState() => _NuevoNegocioState();
}

enum tipo {male, female}

class _NuevoNegocioState extends State<NuevoNegocio> {

  final FirebaseApi _firebaseApi = FirebaseApi();

  final _name = TextEditingController();
  final _description = TextEditingController();
  bool _activo = true;

  String? _tipo;
  final List<String> lista = ['tienda', 'restaurante', 'otro'];

  String _uid = 'ozfjnvlzkcv';

  LatLng? puntoTocado;

  double _latitud = 15;
  double _longitud = 30;

  DateTime _fechaCreacion = DateTime.now();

  List _Lproductos = [];
  List _Lreservas = [];

  final _productos = TextEditingController();
  final _reservas = TextEditingController();

  File? image;

  void PuntoMarcado() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Menu",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5), // fondo opaco
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        LatLng? tempPunto = puntoTocado;

        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FlutterMap(
                      options: MapOptions(
                        center: tempPunto ?? LatLng(6.268992, -75.566696),
                        zoom: tempPunto == null ? 13 : 15,
                        onTap: (tapPosition, latlng) {
                          setModalState(() {
                            tempPunto = latlng;
                          });
                          setState(() {
                            puntoTocado = latlng;
                            _latitud = latlng.latitude;
                            _longitud = latlng.longitude;
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.tumapa',
                        ),
                        if (tempPunto != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 40,
                                height: 40,
                                point: tempPunto!,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation);
        return SlideTransition(
          position: slide,
          child: child,
        );
      },
    );
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
      puntoTocado = LatLng(posicion.latitude, posicion.longitude);
      _latitud = posicion.latitude;
      _longitud = posicion.longitude;
    });
  }


  @override
  Widget build(BuildContext context) {
    Position posicion;
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Negocio")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 170,
                    child: Stack(children: [
                      image != null
                          ? Image.file(image!, width: 150, height: 150,)
                          : const Image(image: AssetImage("assets/images/logo.png"), width: 150, height: 150,),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                            alignment: Alignment.bottomLeft,
                            onPressed: () {
                              pickImage();
                            },
                            icon: const Icon(Icons.camera_alt)
                        ),
                      )
                    ],),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Nombre del negocio"),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _description,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Escribe una breve decripcion del negocio"),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  DropdownButton<String>(
                    hint: Text('Tipo de negocio'),
                    value: _tipo,
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        _tipo = nuevoValor;
                      });
                    },
                    items: lista.map((String valor) {
                      return DropdownMenuItem<String>(
                        value: valor,
                        child: Text(valor),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 55,),
                      ElevatedButton(
                        onPressed: () {
                          obtenerUbicacion();
                        },
                        child: Text('Posicion Actual'),
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: () {
                          PuntoMarcado();
                        },
                        child: Text('Marcar Ubicacion'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _GuardarNegocio();
                      },
                      child: const Text("Guardar Negocio"))
                ],
              ),
            )
        ),
      ),
    );
  }


  void _GuardarNegocio() async {

    var picture = "";
    var negocio = negocios(
      "",
      _name.text,
      _description.text,
      _activo,
      _tipo,
      _uid,
      picture,
      _latitud,
      _longitud,
      _fechaCreacion,
      _Lproductos,
      _Lreservas,
      _productos.text,
      _reservas.text,
    );
    var result = await _firebaseApi.createNegocioInDB(negocio);

    if (result == 'network-request-failed'){
      showMsg('Revise su conexion a internet');
    } else {
      showMsg('Pelicula guardada');
      Navigator.pop(context);
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

  Future  pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });

    } on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
  }

  Future  pickImageFromCamera() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });

    } on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
  }
}