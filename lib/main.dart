import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  List<Rect> rects = List<Rect>();

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
          child: FittedBox(
            child: SizedBox(
              height: image == null ? height : image.height.toDouble(),
              width: image == null ? width : image.width.toDouble(),
              child: CustomPaint(
                painter: Painter(rects, image),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(imageFile);
    FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

    List<Face> listOfFaces = await faceDetector.processImage(firebaseVisionImage);
    rects.clear();
    for (Face face in listOfFaces) {
      rects.add(face.boundingBox);
    }

    var bytesFromImageFile = imageFile.readAsBytesSync();
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
