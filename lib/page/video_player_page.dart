import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  VideoPlayerPage({required this.videoPath});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late String _currentPosition;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/outputt.mp4')
      ..addListener(() {
        setState(() {
          _currentPosition =
              _controller.value.position.toString().split('.').first;
        });
      });
    _initializeVideoPlayerFuture = _controller.initialize();
    _currentPosition = '00:00:00'; // Başlangıçta süreyi sıfırla
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _downloadVideo() async {
    Directory? appDocDir = await getExternalStorageDirectory();
    if (appDocDir != null) {
      String directoryPath = '${appDocDir.path}/Videos';
      Directory directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      String fileName = 'video.mp4';
      String savePath = '${directory.path}/$fileName';

      ByteData? data = await rootBundle.load('assets/outputt.mp4');
      final buffer = data!.buffer;
      await File(savePath).writeAsBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

      print('Video saved to: $savePath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video İndirildi.'),
        ),
      );
    } else {
      print('Harici depolama dizinine erişilemedi.');
    }
  }

  Widget _buildVideoPlayer() {
    if (_controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller),
            Positioned(
              bottom: 8,
              right: 8,
              child: Text(
                _currentPosition,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video Player',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 74, 173),
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20), // Üstten boşluk
          _buildVideoPlayer(),
          SizedBox(height: 20), // Boşluk
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Icon(Icons.play_arrow),
                onPressed: () {
                  _controller.play();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 74, 173),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                child: Icon(Icons.pause),
                onPressed: () {
                  _controller.pause();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 74, 173),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            label: Text(''),
            icon: Icon(Icons.download_rounded),
            onPressed: _downloadVideo,
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 230, 13, 13),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
