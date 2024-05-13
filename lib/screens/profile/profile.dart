import 'package:clothing_identifier/screens/welcome_page.dart';
import 'package:clothing_identifier/screens/profile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:clothing_identifier/models/favorite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesión'),
                  onTap: () async {
                    await Supabase.instance.client.auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomePage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final userData = snapshot.data!;
            final displayName = userData['username'] ?? 'Usuario Desconocido';
            final email = userData['email'] ?? 'usuario@example.com';

            return Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://i.pinimg.com/564x/e1/b0/b1/e1b0b175b623186a5645d74dc0b78a1b.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: -50,
                      left: 20,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1515621061946-eff1c2a352bd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1089&q=80',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                // Información del usuario
                Text(
                  displayName,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                // Estadísticas
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '150',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Comentarios',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '500',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Seguidores',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '300',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'Siguiendo',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Editar perfil',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sección de imágenes
                const Text(
                  'Outfits Favoritos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<List<Favorite>>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final favorites = snapshot.data!;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: favorites.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final favorite = favorites[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            favorite.clothing?.image ?? '',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final response = await Supabase.instance.client
          .from('users')
          .select('username, email')
          .eq('id', user!.id)
          .single();

      return response as Map<String, dynamic>;
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      throw e;
    }
  }

  Future<List<Favorite>> getData() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('outfitsfavorites')
          .select('*, user:users(*), clothing:outfits(*)')
          .eq('user_id', supabase.auth.currentUser?.id ?? '')
          .order('id', ascending: false);

      final tempList = response as List;
      return tempList.map((e) => Favorite.fromJson(e)).toList();
    } catch (e) {
      print('Error al obtener favoritos: $e');
      return [];
    }
  }
}
