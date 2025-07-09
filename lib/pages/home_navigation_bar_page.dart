import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:searchbot/pages/detail_negocio_page.dart';
import 'package:searchbot/pages/my_profile_page.dart';
import 'package:searchbot/pages/nuevo_negocio.dart';
import 'package:searchbot/pages/sign_in_page.dart';
import 'package:searchbot/repository/firebase_api.dart';

class HomeNavigationBarPage extends StatefulWidget {
  const HomeNavigationBarPage(this.posicionActual, {super.key, required this.uid});

  final dynamic posicionActual;
  final String? uid;

  @override
  State<HomeNavigationBarPage> createState() => _HomeNavigationBarPageState(posicionActual);
}

class _HomeNavigationBarPageState extends State<HomeNavigationBarPage> {

  late Stream<List<String>> NegociosFuturo;

  int _selectedIndex = 0;
  final searchText = TextEditingController();
  final FirebaseApi _firebaseApi = FirebaseApi();

  late PopupMenuItem<String> items;



  late final posicionActual;
  _HomeNavigationBarPageState(this.posicionActual);

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
  }

  late var result=FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    //NegociosFuturo = obtenerNegocios();
    //print(widget.uid);
    loadItems();
    obtenerUbicacion();
    super.initState();
    searchText.addListener(() {
    final texto = searchText.text.trim();
    if (texto.isEmpty) {
    setState(() {
    negociosEncontrados.clear();
    });
    }
    });
  }

  void loadItems() {
    final Popup = desplegable();
    setState(() {
      items = Popup;
    });
  }


  PopupMenuItem<String> desplegable() {
    result = FirebaseAuth.instance.currentUser;
    print("desplegable: $result");
    if (result==null) {
      return PopupMenuItem(
          child: Text('Iniciar sesion'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SignInPage()
              ),
            );
          }
      );
    }
    else {
      return PopupMenuItem(
        child: Text('Cerrar sesion'),
        onTap: _onSignOutButtonClicked,
      );
    }
  }

  void _onSignOutButtonClicked() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      loadItems();
    });
  }

  Stream<List<String>> obtenerNegocios(String uid) {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .snapshots()
        .map((doc){
      final data = doc.data();
      return List<String>.from(data?['LNegocios'] ?? []);
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> obtenerUbicacionnes() async {
    final doc = await FirebaseFirestore.instance.collection('negocio').doc().get();
    //print(doc);
    return doc;
  }

  Future<List<String>> obtenerNombresDeNegocios(List<String> idsNegocios) async {
    final firestore = FirebaseFirestore.instance;
    final nombres = <String>[];
    for (String id in idsNegocios) {
      final doc = await firestore.collection('negocio').doc(id).get();
      if (doc.exists) {
        print(doc.data()?['nombre']);
        nombres.add(doc.data()?['nombre'] ?? 'Negocio sin nombre');
      }
    }
    return nombres;
  }

  void mostrarMenuLateral(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Menu",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5), // fondo opaco
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              height: double.infinity,
              color: Colors.white70,
              child: Column(
                children: [
                  SizedBox(height: 35,),
                  TextButton(
                    child: Text("Mi perfil"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyProfilePage()
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: Row(
                      children: [
                        Icon(Icons.star),
                        SizedBox(width: 10,),
                        Text("Lugares favoritos")
                      ],
                    ),
                    onPressed: () {
                      obtenerUbicacionnes();
                    },
                  ),
                  TextButton(
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 10,),
                        Text("Tipo de busqueda")
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyProfilePage()
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 10,),
                        Text("Rango de busqueda")
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyProfilePage()
                        ),
                      );
                    },
                  ),
                  FirebaseAuth.instance.currentUser!=null?
                  ExpansionTile(
                    title: Row(
                      children: [
                        Icon(Icons.home_filled),
                        SizedBox(width: 10,),
                        Text( "Negocios", style: TextStyle(color: Colors.deepPurple))
                      ],
                    ),
                    children: [
                      widget.uid!.isNotEmpty?
                      StreamBuilder<List<String>>(
                        stream: obtenerNegocios(widget.uid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          if (snapshot.hasError)
                            return Center(child: Text('Error al cargar datos'));
                          print(snapshot.data);
                          final negocios = snapshot.data ?? [];
                          if (negocios.isEmpty)
                            return Center(child: Text('Sin negocios'));
                          return FutureBuilder<List<String>>(
                                  future: obtenerNombresDeNegocios(negocios),
                                  builder: (context, snapshotNombres) {
                                    if (snapshotNombres.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final nombres = snapshotNombres.data ?? [];
                                    return SizedBox(
                                      height: 200,
                                      child: ListView(
                                        children: nombres.asMap().entries.map((entry) {
                                          int index = entry.key;
                                          String i = entry.value;
                                          return ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => DetailNegocioPage(nID:negocios[index])
                                                ),
                                              );
                                            },
                                            child: Text('${i}'),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  });
                        },
                      ):Text(""),

                      ListTile(
                        title: TextButton(
                          child: Row(
                            children: [
                              Icon(Icons.add_box_outlined),
                              SizedBox(width: 10,),
                              Text("Nuevo Negocio"),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NuevoNegocio()
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ):Text(''),
                  TextButton(
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 10,),
                        Text("Compartir direccion")
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyProfilePage()
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10,),
                        Text("Configuraciones")
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyProfilePage()
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween<Offset>(
          begin: Offset(-1, 0),
          end: Offset(0, 0),
        ).animate(animation);

        return SlideTransition(
          position: slide,
          child: child,
        );
      },
    );
  }


  List<Map<String, dynamic>> negociosEncontrados = [];
  bool buscando = false;
  Future<void> buscarProductoEnNegocios(String nombreProducto) async {
    setState(() {
      buscando = true;
      negociosEncontrados.clear();
    });
    final negocios = await FirebaseFirestore.instance.collection('negocio').get();
    for (var negocioDoc in negocios.docs) {
      final productosSnap = await FirebaseFirestore.instance
          .collection('negocio')
          .doc(negocioDoc.id)
          .collection('productos')
          .where('nombre', isEqualTo: nombreProducto)
          .get();
      if (productosSnap.docs.isNotEmpty) {
        final data = negocioDoc.data();
        negociosEncontrados.add({
          'nombre': data['nombre'] ?? 'Sin nombre',
          'NID': data['NID'] ?? negocioDoc.id, // usa campo NID si existe, si no, usa ID del documento
        });
      }
    }
    setState(() {
      buscando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MapaNegocios(posicionActual: posicionActual),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 50,),
                          TextFormField(
                            controller: searchText,
                            decoration:  InputDecoration(
                                filled: true,
                                fillColor: Colors.grey,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: IconButton(
                                    onPressed: () {
                                      mostrarMenuLateral(context);
                                    },
                                    icon: Icon(Icons.list)),

                                suffixIcon: PopupMenuButton<String>(
                                  icon: Icon(Icons.adb_outlined),
                                  onSelected: (value) {
                                    print("Seleccionaste: $value");
                                    // Puedes manejar la opción seleccionada
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    items
                                  ],
                                ),
                                labelText: "Buscar",
                            ),
                            onFieldSubmitted: (searchText) {
                              final nombreBuscado = searchText.trim();
                              if (nombreBuscado.isNotEmpty) {
                                buscarProductoEnNegocios(nombreBuscado);
                              }
                            },
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          SizedBox(height: 16,),
                          buscando
                              ? CircularProgressIndicator()
                              :negociosEncontrados.isNotEmpty
                              ? Column(
                            children: negociosEncontrados.map((negocio) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple[100],
                                    foregroundColor: Colors.deepPurple[900],
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailNegocioPage(nID: negocio['NID'],)
                                      ),
                                    );
                                  },
                                  child: Text(
                                    negocio['nombre'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                              : SizedBox.shrink(),
                        ],
                      ),
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

class MapaNegocios extends StatelessWidget {
  final LatLng posicionActual;

  const MapaNegocios({super.key, required this.posicionActual});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('negocio').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay negocios registrados"));
        }

        final negocios = snapshot.data!.docs;
        return FlutterMap(
          options: MapOptions(
            initialCenter: posicionActual ?? LatLng(4.6097, -74.0817),  // <- posición actual
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.ejemplo.tumapa',
            ),
            MarkerLayer(
              markers: [
                ...negocios.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Marker(
                    width: 800.0,
                    height: 80.0,
                    point: LatLng(data['latitud'], data['longitud']),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailNegocioPage(nID: data['NID']),
                              ),
                            );
                          },
                          icon: const Icon(Icons.location_on, size: 30, color: Colors.red),
                        ),
                        Text(
                          data['nombre'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }),
                //
                Marker(
                  point: posicionActual,
                  width: 60,
                  height: 60,
                  child: const Icon(Icons.my_location, size: 30, color: Colors.blue),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}