import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? imageSelect;
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageSelect == null
              ? AspectRatio(
                  aspectRatio: 1.5,
                  child: Container(
                    color: Colors.pink[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image),
                        Text('No image select'),
                      ],
                    ),
                  ),
                )
              : AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.file(
                    File(imageSelect!.path),
                    fit: BoxFit.cover,
                  ),
                ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  pickImageCamera();
                },
                child: Text('Pick Image Camera'),
              ),
              ElevatedButton(
                onPressed: () {
                  pickImageGallery();
                },
                child: Text('Pick Image Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pickImageCamera() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageSelect = File(image.path);
      });
    }
  }

  pickImageGallery() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageSelect = File(image.path);
      });
    }
  }
}
