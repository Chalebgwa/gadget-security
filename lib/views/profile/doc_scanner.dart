import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'dart:async';


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
    //scanDocument();
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
