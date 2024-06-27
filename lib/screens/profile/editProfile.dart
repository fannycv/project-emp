import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isCompany = false; // Estado para controlar si es una empresa

  File? _coverImage;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    // Cargar datos del usuario desde Supabase al iniciar
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final response = await Supabase.instance.client
          .from('users') // Asegúrate de tener una tabla "users" en Supabase
          .select()
          .eq('id', user!.id) // Filtrar por el ID del usuario
          .single();

      _usernameController.text = response['username'];
      _emailController.text = response['email'];
      _isCompany =
          response['is_company'] ?? false; // Actualiza el estado de empresa
    } catch (e) {
      // Manejar errores al cargar datos
      print('Error al cargar datos del usuario: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = Supabase.instance.client.auth.currentUser;
        await Supabase.instance.client.from('users').update({
          'username': _usernameController.text,
          'email': _emailController.text,
          'is_company': _isCompany, // Actualiza el campo is_company

          // Puedes agregar más campos aquí si es necesario
        }).eq('id', user!.id);

        // Actualiza el perfil de autenticación si cambiaste el correo electrónico
        if (_emailController.text != user.email) {
          await Supabase.instance.client.auth
              .updateUser(UserAttributes(email: _emailController.text));
        }

        // Muestra un mensaje de éxito o navega de regreso al perfil
        Navigator.pop(context); // Vuelve al perfil
      } catch (e) {
        // Manejar errores al actualizar
        print('Error al actualizar el perfil: $e');
      }
    }
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Para evitar el desbordamiento
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: _pickCoverImage,
                      child: _coverImage != null
                          ? Image.file(
                              _coverImage!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
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
                    ),
                    Positioned(
                      top: 95,
                      right: 10,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 215, 211, 211),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(0.3),
                        child: IconButton(
                          iconSize: 30, // Tamaño del icono
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                          onPressed: _pickCoverImage,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: 20,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: _pickProfileImage,
                            child: _profileImage != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    backgroundImage: FileImage(_profileImage!),
                                  )
                                : const CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1515621061946-eff1c2a352bd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1089&q=80',
                                    ),
                                  ),
                          ),
                          Positioned(
                            top: 85,
                            right: 10,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 215, 211, 211),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(0.3),
                              child: IconButton(
                                iconSize: 20, // Tamaño del icono
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                                onPressed: _pickProfileImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 70),

                // Campos de edición con padding solo para los input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            labelText: 'Nombre de usuario'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un nombre de usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Correo electrónico'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un correo electrónico';
                          }
                          if (!value.contains('@')) {
                            return 'Por favor ingresa un correo electrónico válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      /*
                      // Checkbox para indicar si es una empresa
                      CheckboxListTile(
                        
                        title: const Text('¿Eres una empresa?'),
                        value: _isCompany,
                        onChanged: (value) {
                          setState(() {
                            _isCompany = value ??
                                false; // Actualizar el estado de empresa
                          });
                        },
                      ),
                    */
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Botón de guardar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
