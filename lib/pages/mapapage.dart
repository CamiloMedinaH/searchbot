import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:searchbot/pages/my_profile_page.dart';

class Mapapage extends StatefulWidget {

  const Mapapage(this.posicionActual, {super.key});

  final dynamic posicionActual;
  @override
  State<Mapapage> createState() => _MapapageState(posicionActual);
}

class _MapapageState extends State<Mapapage> {

  final posicionActual;
  _MapapageState(this.posicionActual);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa OpenStreetMap')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: posicionActual,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ejemplo.tumapa',
          ),
          MarkerLayer(
            markers: [
              Marker(
                child: Builder(
                  builder: (ctx) => const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                width: 80.0,
                height: 80.0,
                point: posicionActual, // Mismo punto que el centro
              ),
              Marker(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyProfilePage()
                      ),
                    );
                  },
                  icon: Icon(Icons.location_on, size: 30, color: Colors.red,),
                ),
                width: 80.0,
                height: 80.0,
                point: LatLng(6.268762637372491, -75.56821722330325), // Mismo punto que el centro
              ),
            ],
          ),
        ],
      ),
    );
  }
}
