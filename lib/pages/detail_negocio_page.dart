import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailNegocioPage extends StatefulWidget {


  const DetailNegocioPage({required this.nID, super.key});


  final String? nID;

  @override
  State<DetailNegocioPage> createState() => _DetailNegocioPageState(nID);
}

class _DetailNegocioPageState extends State<DetailNegocioPage> {
  final nID;

  _DetailNegocioPageState(this.nID);

  Future<DocumentSnapshot<Map<String,dynamic>>> obtenerInformacionDocumento(String id) async {
    final docRef = FirebaseFirestore.instance.collection('negocio').doc(id);
    final docSnapshot = await docRef.get();
    return docSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion del Negocio'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        future: obtenerInformacionDocumento(nID),
        builder: (context, snapshotNegocio) {
          if (snapshotNegocio.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator());
          }
          final negocio = snapshotNegocio.data;
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage("assets/images/logo.png"),
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 16,),
                  Text("Nombre: ${negocio?['nombre']}", style: TextStyle(fontSize: 24),),
                  SizedBox(height: 16,),
                  Text("Tipo de Negocio: ${negocio?['tipo']}", style: TextStyle(fontSize: 24),),
                  SizedBox(height: 16,),
                  Text("Descripcion: ${negocio?['description']}", style: TextStyle(fontSize: 24),),
                  SizedBox(height: 16,),
                  Text("Estado del Negocio ${negocio?['activo']?"activo":"no activo"}", style: TextStyle(fontSize: 24),)
                ],
              ),
            )
          );
        },
      ),
    );
  }
}
