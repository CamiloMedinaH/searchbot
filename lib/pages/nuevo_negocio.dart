import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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



  double _latitud = 15;
  double _longitud = 30;

  DateTime _fechaCreacion = DateTime.now();

  List _Lproductos = [];
  List _Lreservas = [];

  final _productos = TextEditingController();
  final _reservas = TextEditingController();

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Negocio")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                ElevatedButton(
                    onPressed: () {
                      _GuardarNegocio();
                    },
                    child: const Text("Guardar Negocio"))
              ],
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