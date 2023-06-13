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
        title: const Text('Media Selection'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: _selectedImage != null
                  ? Image.file(_selectedImage!)
                  : const Text('No image selected'),
            ),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          Expanded(
            child: Center(
              child: _selectedVideo != null
                  ? Text('Video selected: ${_selectedVideo!.path}')
                  : const Text('No video selected'),
            ),
          ),
          ElevatedButton(
            onPressed: _pickVideo,
            child: const Text('Pick Video'),
          ),
          ElevatedButton(
            onPressed: _createVideo,
            child: const Text('Create Video'),
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
            title: const Text('Error'),
            content: const Text('Please select an image and a video.'),
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
              print("Video Yolu: $videoPath"); // Print the video path
              return VideoPlayerPage(
                videoPath: videoPath,
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
