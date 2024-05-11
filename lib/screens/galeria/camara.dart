import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _image;

  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Imagen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Seleccionar imagen'),
            ),
            SizedBox(height: 20),
            _image != null
                ? ElevatedButton(
                    onPressed: () {
                      // Aquí puedes escribir el código para subir la imagen
                      // a tu servicio en la nube.
                      // Por ejemplo, puedes usar Firebase Storage o algún
                      // otro servicio de almacenamiento en la nube.
                      // Luego de subir la imagen, puedes mostrar un mensaje
                      // o realizar alguna acción.
                      // Aquí solo mostramos un mensaje temporal.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Imagen subida con éxito.'),
                        ),
                      );
                    },
                    child: Text('Subir imagen'),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}