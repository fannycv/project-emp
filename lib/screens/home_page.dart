import 'package:clothing_identifier/screens/autentificacion/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de la pantalla
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black, 
          ),
          // Carrusel de imágenes
          Positioned.fill(
            child: CarouselSlider(
              items: [
                
                'assets/images/inicio8.jpeg',
                'assets/images/inicio9.jpg',
                'assets/images/inicio6.png',
              ].map((imagePath) {
                return Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                );
              }).toList(),
              options: CarouselOptions(
                height: double.infinity, // Ajusta la altura del carrusel
                viewportFraction: 1.0,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
            ),
          ),
          // Arco para la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: MyClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *
                    0.55, // Ajusta la altura de la parte inferior
                color: Colors.white, // Puedes cambiar el color de fondo
                child: Padding(
                  padding: const EdgeInsets.only(top: 130, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'VISION8',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Explora y crea tu estilo con Vision8: encuentra prendas únicas y descubre opciones similares para looks perfectos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Botón de flecha
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 193, 193, 193),
                          ),
                          child: Center(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 139, 142, 144),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(
        0, size.height * 0.35); // Comienza desde la esquina inferior izquierda
    path.quadraticBezierTo(size.width / 2, 0, size.width,
        size.height * 0.35); // Curva hacia la esquina inferior derecha
    path.lineTo(
        size.width, size.height); // Línea hacia la esquina superior derecha
    path.lineTo(0, size.height); // Línea hacia la esquina superior izquierda
    path.close(); // Cierra el path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
