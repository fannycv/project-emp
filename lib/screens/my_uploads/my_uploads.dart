import 'dart:convert';
import 'dart:io';

import 'package:clothing_identifier/models/clothing.dart';
import 'package:clothing_identifier/screens/clothing_detail.dart';
import 'package:clothing_identifier/screens/my_uploads/my_clothings.dart';
import 'package:clothing_identifier/screens/my_uploads/my_outfits.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final supabase = Supabase.instance.client;

class MyUploadView extends StatefulWidget {
  const MyUploadView({super.key});

  @override
  State<MyUploadView> createState() => _MyUploadViewState();
}

class _MyUploadViewState extends State<MyUploadView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(child: Text('Clothings')),
            Tab(
              child: Text('Outfits'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          MyClothingView(),
          MyOutfitView(),
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
          'is_outfit': false,
        });

        if (openai.data != null) {
          if (openai.data['message'] == "NO ES UNA PRENDA DE VESTIR" ||
              openai.data['message'] == "NO ES UNA PRENDA") {
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
              .from('clothings')
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

  Future<List<Clothing>> getData() async {
    try {
      final response = await supabase
          .from('clothings')
          .select('*')
          .eq('auth_user_id', supabase.auth.currentUser?.id ?? '');

      final tempList = response as List;

      return tempList.map((e) => Clothing.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
