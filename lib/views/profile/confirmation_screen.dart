import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ConfirmDevice extends StatefulWidget {
  ConfirmDevice({Key key}) : super(key: key);

  @override
  _ConfirmDeviceState createState() => _ConfirmDeviceState();
}

class _ConfirmDeviceState extends State<ConfirmDevice> {
  File file;
  bool isPdf = false;

  Future<void> cameraScan() async {
    var _file = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      file = _file;
      isPdf = false;
    });
  }

  Future<void> pickPdf() async {
    var _file =
        await FilePicker.getFile(fileExtension: "pdf", type: FileType.CUSTOM);
    setState(() {
      file = _file;
      isPdf = true;
    });
  }

  Future<void> pickImage() async {
    var _file = await FilePicker.getFile();
    setState(() {
      file = _file;
      isPdf = false;
    });
  }

  void toggleBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.image,
                color: Colors.blue,
              ),
              onPressed: pickImage,
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.camera,
                color: Colors.purple,
              ),
              onPressed: cameraScan,
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.filePdf,
                color: Colors.red,
              ),
              onPressed: pickPdf,
            ),
          ],
        );
      },
    );
  }

  void save() {
    Navigator.pop(context, file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: toggleBottomSheet,
        child: Icon(FontAwesomeIcons.plus),
      ),
      appBar: AppBar(
        title: Text("Add Device Reciept"),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.check),
            onPressed: () {
              Navigator.pop(context, file);
            },
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: !isPdf
            ? Image.file(
                file,
                fit: BoxFit.fitHeight,
              )
            : Container(
                child: file != null
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.filePdf,
                              size: 200,
                              color: Colors.pink,
                            ),
                            ListTile(
                              title: Text(
                                path.basename(file.path),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),
      ),
    );
  }
}
