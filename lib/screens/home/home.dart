import 'package:clothing_identifier/screens/galeria.dart';
import 'package:clothing_identifier/screens/galeria/camara.dart';
import 'package:clothing_identifier/screens/home/Inicio.dart';
import 'package:clothing_identifier/screens/my_uploads/my_uploads.dart';
import 'package:flutter/material.dart';
import 'package:clothing_identifier/screens/favoritos/favoritos.dart';
import 'package:clothing_identifier/screens/clothing.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    InicioView(),
    FavoritesPage(),
    MyUploadView(),
    const GaleriaView(),
    ClothingView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // if (_selectedIndex == 2) {
      //   _showCameraOptionsModal(context);
      // }
    });
  }

  // Función para mostrar el modal de opciones de la cámara
  void _showCameraOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cerrar el modal
                  _navigateToSelectFilePage(); // Navegar a la página para seleccionar archivo
                },
                child: const Text('Seleccionar Archivo'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Acción al usar la cámara
                  Navigator.pop(context); // Cerrar el modal
                  // Aquí puedes agregar la lógica para usar la cámara
                },
                child: Text('Usar Cámara'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Función para navegar a la página para seleccionar archivo
  void _navigateToSelectFilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageUploader()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'VISION8',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClothingView()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1515621061946-eff1c2a352bd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1089&q=80',
                ),
              ),
            ),
          ),
        ],
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.browse_gallery),
            label: 'Galeria',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'TourBuddy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_travel),
              title: const Text('Recursos'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.travel_explore),
              title: const Text('Recomendaciones'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favoritos'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClothingView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                // Implementa aquí el cierre de sesión
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showCameraOptionsModal(context);
      //   },
      //   tooltip: 'Seleccionar Archivo',
      //   child: const Icon(Icons.camera_alt),
      // ),
    );
  }
}
