import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'video_player_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? _selectedImage;
  File? _selectedVideo;
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medya Seçimi',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor:
            Color.fromARGB(255, 0, 74, 173), // AppBar'ın arka plan rengi
        elevation: 0, // AppBar'ın gölgelendirme efekti
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Butonun kenar yuvarlatma
        ), // Başlığın ortalanması
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: _selectedImage != null
                  ? Image.file(_selectedImage!)
                  : const Text('Resim Seçilmedi'),
            ),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Resim Seçiniz'),
            style: ElevatedButton.styleFrom(
              primary:
                  Color.fromARGB(255, 0, 74, 173), // Butonun arka plan rengi
              onPrimary: Colors.white, // Butonun metin rengi
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Butonun kenar yuvarlatma
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10), // Butonun iç içe boşluğu
            ),
          ),
          Expanded(
            child: Center(
              child: _selectedVideo != null
                  ? Text('Video seçildi: ${_selectedVideo!.path}')
                  : const Text('Video Seçilmedi'),
            ),
          ),
          ElevatedButton(
            onPressed: _pickVideo,
            child: const Text('Video Seçiniz'),
            style: ElevatedButton.styleFrom(
              primary:
                  Color.fromARGB(255, 0, 74, 173), // Butonun arka plan rengi
              onPrimary: Colors.white, // Butonun metin rengi
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Butonun kenar yuvarlatma
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10), // Butonun iç içe boşluğu
            ),
          ),
          ElevatedButton(
            onPressed: _createVideo,
            child: const Text('Video Oluştur'),
            style: ElevatedButton.styleFrom(
              primary:
                  Color.fromARGB(255, 230, 13, 13), // Butonun arka plan rengi
              onPrimary: Colors.white, // Butonun metin rengi
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Butonun kenar yuvarlatma
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10), // Butonun iç içe boşluğu
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
      });
    }
  }

  Future<void> _createVideo() async {
    if (_selectedImage == null || _selectedVideo == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Hata'),
            content: const Text('Lütfen resim ve video seçiniz.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final url = Uri.parse(
        'http://192.168.1.107:8000/generate_animation'); // Replace with your server URL

    var request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath('photo', _selectedImage!.path),
    );

    request.files.add(
      await http.MultipartFile.fromPath('video', _selectedVideo!.path),
    );

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = response.bodyBytes;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              final videoPath = jsonDecode(response.body)['result'];
              final modifiedVideoPath = videoPath.replaceAll("\\", '/');
              print("Video Yolu: $modifiedVideoPath"); // Print the video path
              return VideoPlayerPage(
                videoPath: modifiedVideoPath,
              );
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  Text('Failed to create video. Error: ${response.statusCode}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to create video. Error: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
