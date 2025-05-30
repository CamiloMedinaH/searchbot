import 'package:flutter/material.dart';
import 'package:searchbot/pages/my_profile_page.dart';
import 'package:searchbot/pages/sign_in_page.dart';
import 'package:searchbot/pages/sign_up_page.dart';

import 'package:searchbot/repository/firebase_api.dart';

class HomeNavigationBarPage extends StatefulWidget {
  const HomeNavigationBarPage({super.key});

  @override
  State<HomeNavigationBarPage> createState() => _HomeNavigationBarPageState();
}

class _HomeNavigationBarPageState extends State<HomeNavigationBarPage> {

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
              width: MediaQuery.of(context).size.width * 0.75,
              height: double.infinity,
              color: Colors.white,
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
                  )
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





    /*
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis peliculas"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Mis peliculas"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Mi Perfil"
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );*/


  }
}
