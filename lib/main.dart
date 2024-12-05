import 'package:flutter/material.dart';
import 'package:live_video_caption/camera_stream.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraStream(),
    );
  }
}
