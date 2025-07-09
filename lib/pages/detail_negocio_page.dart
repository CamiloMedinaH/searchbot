import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchbot/models/productos.dart';
import 'package:searchbot/repository/firebase_api.dart';

class DetailNegocioPage extends StatefulWidget {


  const DetailNegocioPage({required this.nID, super.key});


  final String? nID;


  @override
  State<DetailNegocioPage> createState() => _DetailNegocioPageState(nID);
}

class _DetailNegocioPageState extends State<DetailNegocioPage> {
  final nID;

  final FirebaseApi _firebaseApi = FirebaseApi();

  _DetailNegocioPageState(this.nID);

  Stream<DocumentSnapshot<Map<String,dynamic>>> obtenerInformacionDocumento(String id) {
    final docRef = FirebaseFirestore.instance.collection('negocio').doc(id);
    final docSnapshot = docRef.snapshots();
    return docSnapshot;
  }

  final uid = FirebaseAuth.instance.currentUser;
  bool activo = false;
  TextEditingController prueba = TextEditingController(text: 'holaa');

  Stream<List<String>> obtenerProductos(String nid) {
    return FirebaseFirestore.instance
        .collection('negocio')
        .doc(nid)
        .collection('productos')
        .doc()
        .snapshots()
        .map((doc){
      final data = doc.data();
      return List<String>.from(data?['PID'] ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion del Negocio'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        stream: obtenerInformacionDocumento(nID),
        builder: (context, snapshotNegocio) {
          if (snapshotNegocio.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator());
          }
          final negocio = snapshotNegocio.data;
          print(negocio?['UID']);
          print(FirebaseAuth.instance.currentUser?.uid);
          prueba.text = negocio?['description'];
          activo = FirebaseAuth.instance.currentUser?.uid==negocio?['UID']?false:true;
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
                  TextFormField(
                    readOnly: activo,
                    controller: prueba,
                    onFieldSubmitted: (a) async {
                      await FirebaseFirestore.instance
                          .collection('negocio')
                          .doc(negocio?['NID'])
                          .update({'description': a});
                      print('Actualizado');
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: negocio?['description'],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text("Estado del Negocio ${negocio?['activo']?"activo":"no activo"}", style: TextStyle(fontSize: 24),),
                  SizedBox(height: 10,),

                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      title: Row(
                        children: [
                          //Icon(Icons.),
                          SizedBox(width: 10,),
                          Text( "Productos", style: TextStyle(color: Colors.deepPurple))
                        ],
                      ),
                      children: [
                        //widget.uid!.isNotEmpty?
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('negocio').doc(nID).collection('productos').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError){
                              return const Center(child: Text('Error al cargar los productos'),);
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(),);
                            }
                            final productos = snapshot.data!.docs;
                            return Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: productos.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final nombre = data['nombre'] ?? 'Sin nombre';
                                final unidades = data['Unidades'] ?? 'Sin unidades';
                                final precios = data['Precio'] ?? 'Sin precio';
                                final pid = data['PID'] ?? '';
                                return Row(
                                  children: [
                                    Image(image: AssetImage("assets/images/logo.png"),
                                      width: 50,
                                      height: 50,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        Row(
                                          children: [
                                            Text('Unidades: $unidades', style: TextStyle(color: Colors.grey[600])),
                                            SizedBox(width: 10,),
                                            Text('C/U: $precios', style: TextStyle(color: Colors.grey[600])),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    !activo? IconButton(
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('negocio')
                                              .doc(nID) // ID del negocio
                                              .collection('productos')
                                              .doc(pid) // ID del producto
                                              .delete();

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Producto eliminado")),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Error al eliminar: $e")),
                                          );
                                        }
                                      },
                                      icon: Icon(Icons.delete),
                                    ):Text('')
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  !activo? ElevatedButton(
                    onPressed: () {
                      AgregarProducto();
                    },
                    child: Text('Nuevo producto'),
                  ):Text('')
                ],
              ),
            )
          );
        },
      ),
    );
  }

  final _nombreP = TextEditingController();
  final _descriptionP = TextEditingController();
  final _Precio = TextEditingController();
  final _Unidades = TextEditingController();

  void AgregarProducto() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Menu",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5), // fondo opaco
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.white,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage("assets/images/logo.png"),
                                width: 150,
                                height: 150,
                              ),
                              SizedBox(height: 16,),
                              TextFormField(
                                controller: _nombreP,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(), labelText: "Nombre del Producto"),
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 16,),
                              TextFormField(
                                controller: _descriptionP,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(), labelText: "Descripcion del Producto"),
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 16,),
                              TextFormField(
                                controller: _Precio,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(), labelText: "Precio del Producto"),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 16,),
                              TextFormField(
                                controller: _Unidades,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(), labelText: "Unidades del Producto"),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 16,),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  SizedBox(width: 10,),
                                  ElevatedButton(
                                    onPressed: () {
                                      _GuardarProducto();
                                    },
                                    child: Text('Guardar'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ),
                    )
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

  void _GuardarProducto() async {

    var picture = "";
    var producto = productos(
      _descriptionP.text,
      _nombreP.text,
      picture,
      _Precio.text,
      _Unidades.text,
      "",
    );
    var result = await _firebaseApi.createProductoInDB(producto, nID);

    if (result == 'network-request-failed'){
      showMsg('Revise su conexion a internet');
    } else {
      showMsg('Producto guardada');
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

}
