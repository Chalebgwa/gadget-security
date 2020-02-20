import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tesseract_ocr/tesseract_ocr.dart';

class DocScanner extends StatefulWidget {
  @override
  _DocScannerState createState() => _DocScannerState();
}

class _DocScannerState extends State<DocScanner> {
  String _extractText = 'Unknown';
  File file;

  @override
  void initState() {
    super.initState();
    ScanDocument();
  }

  Future<void> ScanDocument() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    extractText(file);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> extractText(File file) async {
    String extractText;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String imagePath = file.path;

      //final ByteData data =
      //    await rootBundle.load('packages/tesseract_ocr/images/test.png');
      //final Uint8List bytes = data.buffer.asUint8List(
      //  data.offsetInBytes,
      //  data.lengthInBytes,
      //);
      //await File(imagePath).writeAsBytes(bytes);

      extractText =
          await TesseractOcr.extractText(imagePath, language: "financial");
    } on PlatformException {
      extractText = 'Failed to extract text';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _extractText = extractText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Tesseract OCR'),
          ),
          body: Column(
            children: <Widget>[
              Center(
                child: Text('Detected Text: $_extractText\n'),
              ),
              //Image.asset('images/test.png', package: 'tesseract_ocr', height: 30.0),
            ],
          )),
    );
  }
}
