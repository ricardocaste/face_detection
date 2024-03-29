
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaceDetection(),
      theme: ThemeData.dark(),
    );
  }
}

class FaceDetection extends StatefulWidget {
  @override
  _FaceDetectionState createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  ui.Image image;
  List<Rect> rects = [];
  bool isSmiling = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width =  MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Face detection"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: Icon(Icons.camera),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              FittedBox(
                child: SizedBox(
                  height: image == null ? height / 2 : image.height.toDouble(),
                  width: image == null ? width : image.width.toDouble(),
                  child: CustomPaint(
                    painter: Painter(rects, image),
                  ),
                ),
              ),
              SizedBox(height: 30),
              if (image != null)
                Text(
                  isSmiling ? "Smiling 😀" : "Not Smiling 😕",
                  style: TextStyle(color: Colors.white, fontSize: 20)
                ),
            ],
          )
          

        ),
      ),
    );
  }

  Future getImage() async {
    XFile imagePickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final inputImage = InputImage.fromFilePath(imagePickedFile.path);

    final faceDetector = GoogleMlKit.vision.faceDetector();

    final List<Face> faces = await faceDetector.processImage(inputImage);

    rects.clear();
    for (Face face in faces) {
      isSmiling = face.smilingProbability >= 0.6;
      rects.add(face.boundingBox);
    }

    var bytesFromImageFile = await imagePickedFile.readAsBytes();
    decodeImageFromList(bytesFromImageFile).then((img) {
      setState(() {
        image = img;
      });
    });
  }
}

class Painter extends CustomPainter {
  final List<Rect> rects;
  ui.Image image;

  Painter(@required this.rects, @required this.image);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;

    if (image != null) {
      canvas.drawImage(image, Offset.zero, paint);
    }

    for (var i = 0; i <= rects.length - 1; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
