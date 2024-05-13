import 'dart:convert';
import 'dart:io';

import 'package:clothing_identifier/models/clothing.dart';
import 'package:clothing_identifier/screens/clothing_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final supabase = Supabase.instance.client;

class MyOutfitView extends StatefulWidget {
  const MyOutfitView({super.key});

  @override
  State<MyOutfitView> createState() => _MyOutfitViewState();
}

class _MyOutfitViewState extends State<MyOutfitView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Clothing>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else {
            final clothing = snapshot.data!;
            return ListView.builder(
              itemCount: clothing.length,
              itemBuilder: (context, index) {
                final item = clothing[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                          child: SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Image.network(
                              item.image ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${item.description}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ClothingDatailView(clothing: item),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.arrow_forward),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.favorite_border),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: loading
                ? null
                : () {
                    takePicture();
                  },
            tooltip: 'Tomar foto',
            backgroundColor: Colors.black, // Color del fondo del botón
            foregroundColor: Colors.white, // Color del icono
            child: loading
                ? const CircularProgressIndicator()
                : const Icon(Icons.camera_alt),
          ),
          const SizedBox(width: 16), // Espacio entre los botones flotantes
          FloatingActionButton(
            onPressed: loading
                ? null
                : () {
                    selectFile();
                  },
            tooltip: 'Seleccionar archivo',
            backgroundColor: Colors.black, // Color del fondo del botón
            foregroundColor: Colors.white, // Color del icono
            child: loading
                ? const CircularProgressIndicator()
                : const Icon(Icons.attach_file),
          ),
        ],
      ),
    );
  }

  void takePicture() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1280,
        maxHeight: 720,
        imageQuality: 91,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        setState(() {
          loading = true;
        });
        File file = File(photo.path);

        String image =
            'data:image/jpg;base64, ${base64Encode(file.readAsBytesSync())}';

        var openai = await supabase.functions.invoke('openai', body: {
          'image': image,
          'is_outfit': true,
        });

        if (openai.data != null) {
          if (openai.data['message'] == "NO ES UNA PRENDA DE VESTIR" ||
              openai.data['message'] == "NO ES UN OUTFIT COMPLETO") {
            setState(() {
              loading = false;
            });

            print('No es una prenda de vestir');
            return;
          }

          var embedding = await supabase.functions.invoke('embed', body: {
            'input': openai.data['message'],
          });

          // generamos un uuid para la imagen
          var uuid = const Uuid().v4();

          // subimos la imagen a supabase usando el cliente de supabase en el bucket de images
          await supabase.storage.from("images").upload(uuid, file);

          await supabase
              .from('outfits')
              .insert({
                'name': openai.data['name'],
                'description': openai.data['message'],
                'image': uuid,
                'embedding': embedding.data ?? [],
                'auth_user_id': supabase.auth.currentUser?.id,
              })
              .select()
              .single();

          setState(() {
            loading = false;
          });
          getData();
          print('Data inserted');
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Error al subir la imagen");
      print(e);
    }
  }

  void selectFile() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1280,
        maxHeight: 720,
        imageQuality: 91,
      );

      if (pickedFile != null) {
        setState(() {
          loading = true;
        });

        File file = File(pickedFile.path);

        String image =
            'data:image/jpg;base64, ${base64Encode(file.readAsBytesSync())}';

        var openai = await supabase.functions.invoke('openai', body: {
          'image': image,
          'is_outfit': true,
        });

        if (openai.data != null) {
          if (openai.data['message'] == "NO ES UNA PRENDA DE VESTIR" ||
              openai.data['message'] == "NO ES UN OUTFIT COMPLETO") {
            setState(() {
              loading = false;
            });

            print('No es un outfit completo');
            return;
          }

          var embedding = await supabase.functions.invoke('embed', body: {
            'input': openai.data['message'],
          });

          var uuid = Uuid().v4();

          await supabase.storage.from("images").upload(uuid, file);

          await supabase
              .from('outfits')
              .insert({
                'name': openai.data['name'],
                'description': openai.data['message'],
                'image': uuid,
                'embedding': embedding.data ?? [],
                'auth_user_id': supabase.auth.currentUser?.id,
              })
              .select()
              .single();

          setState(() {
            loading = false;
          });
          getData();
          print('Datos insertados');
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Error al seleccionar el archivo");
      print(e);
    }
  }

  Future<List<Clothing>> getData() async {
    try {
      final response = await supabase
          .from('outfits')
          .select('*')
          .eq('auth_user_id', supabase.auth.currentUser?.id ?? '');

      final tempList = response as List;

      return tempList.map((e) => Clothing.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
