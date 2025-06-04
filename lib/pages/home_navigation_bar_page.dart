import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchbot/pages/detail_negocio_page.dart';
import 'package:searchbot/pages/my_profile_page.dart';
import 'package:searchbot/pages/nuevo_negocio.dart';
import 'package:searchbot/pages/sign_in_page.dart';
import 'package:searchbot/pages/sign_up_page.dart';

import 'package:searchbot/repository/firebase_api.dart';

class HomeNavigationBarPage extends StatefulWidget {
  const HomeNavigationBarPage({super.key, required this.uid});

  final String? uid;

  @override
  State<HomeNavigationBarPage> createState() => _HomeNavigationBarPageState();
}

class _HomeNavigationBarPageState extends State<HomeNavigationBarPage> {

  late Stream<List<String>> NegociosFuturo;

  int _selectedIndex = 0;
  final searchText = TextEditingController();
  final FirebaseApi _firebaseApi = FirebaseApi();

  late PopupMenuItem<String> items;

  static const List<Widget> _widgetOptions = [
    MyProfilePage(),
    MyProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //NegociosFuturo = obtenerNegocios();
    print(widget.uid);
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final Popup = await desplegable();
    setState(() {
      items = Popup;
    });
  }

  Future<PopupMenuItem<String>> desplegable() async {
    var result = _firebaseApi.validateSession();
    if (await result) {
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

  void _onSignOutButtonClicked() {
    _firebaseApi.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
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

  Future<List<String>> obtenerNombresDeNegocios(List<String> idsNegocios) async {
    final firestore = FirebaseFirestore.instance;
    final nombres = <String>[];
    for (String id in idsNegocios) {
      final doc = await firestore.collection('negocio').doc(id).get();
      if (doc.exists) {
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
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/fondo1.png",
                  width: double.infinity,
                  fit: BoxFit.cover, ),
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
                                labelText: "Buscar"),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ],
                      ),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
