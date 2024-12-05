import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraStream extends StatefulWidget {
  @override
  _CameraStreamState createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool isStreaming = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.veryHigh);

    await _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startStreaming() async {
    if (!_controller.value.isInitialized || isStreaming) return;

    isStreaming = true;

    _controller.startImageStream((CameraImage image) async {
      // Convert CameraImage to a format Flask can handle
      final bytes = concatenatePlanes(image.planes);
      final base64Image = base64Encode(bytes);

      // Send to Flask
      // await sendFrameToBackend(base64Image);
    });
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    return Uint8List.fromList(planes.expand((plane) => plane.bytes).toList());
  }

  // Future<void> sendFrameToBackend(String base64Image) async {
  //   final url = Uri.parse('http://<YOUR_FLASK_SERVER_IP>:5000/upload_frame');
  //   await http.post(url, body: jsonEncode({'image': base64Image}));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Stream')),
      body: _controller.value.isInitialized
          ? CameraPreview(_controller)
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: startStreaming,
        child: Icon(Icons.videocam),
      ),
    );
  }
}
