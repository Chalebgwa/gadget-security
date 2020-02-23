import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/views/profile/confirmation_screen.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class LaptopForm extends StatefulWidget {
  @override
  _LaptopFormState createState() => _LaptopFormState();
}

class _LaptopFormState extends State<LaptopForm> {
  File file;
  bool _uploaded = false;
  TextEditingController _ssnController = new TextEditingController();
  TextEditingController _imeiController = new TextEditingController();
  TextEditingController _deviceNameController = new TextEditingController();
  Auth _auth;
  DeviceProvider _deviceProvider;
  String filename;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _deviceProvider = Provider.of<DeviceProvider>(context);
  }

  void save() {
    var _ssn = _ssnController.text;
    var _imei = _imeiController.text;
    var _name = _deviceNameController.text;
    var id = _auth.currentUser.id;

    Device _device = Device(
      _ssn,
      id,
      _name,
      confirmed: false,
      imei: _imei,
    );

    _auth.addDevice(_device, file);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  "UPLOAD DEVICE INFO",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                width: double.maxFinite,
                height: 100,
                color: Theme.of(context).primaryColor,
                alignment: Alignment.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _deviceNameController,
                  decoration: InputDecoration(
                    hintText: "Device Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _ssnController,
                  decoration: InputDecoration(
                    hintText: "SSN",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _imeiController,
                  decoration: InputDecoration(
                    hintText: "IMEI",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text(filename ?? "ADD PROOF OF OWNERSHIP",textAlign: TextAlign.center,),
                  onPressed: () async {
                    var _file = await Navigator.push<File>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmDevice(),
                      ),
                    );

                    if (_file != null) {
                      setState(() {
                        file = _file;
                        filename = path.basename(file.path);
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text("SAVE"),
                  onPressed: save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
