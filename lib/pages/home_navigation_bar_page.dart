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

  static const List<Widget> _widgetOptions = [
    MyProfilePage(),
    MyProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSignOutButtonClicked() {
    _firebaseApi.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
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

                                    },
                                    icon: Icon(Icons.list)),

                                suffixIcon: PopupMenuButton<String>(
                                  icon: Icon(Icons.adb_outlined),
                                  onSelected: (value) {
                                    print("Seleccionaste: $value");
                                    // Puedes manejar la opción seleccionada
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                      child: Text('Iniciar sesion'),
                                    ),
                                    PopupMenuItem(
                                      child: Text('Cerrar sesion'),
                                      onTap: _onSignOutButtonClicked,
                                    ),
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
