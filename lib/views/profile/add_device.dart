import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:provider/provider.dart';

class AddDevice extends StatefulWidget {
  final DeviceProvider deviceProvider;

  AddDevice({Key key, this.deviceProvider}) : super(key: key);

  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController ssnController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Auth _auth;

  String ssn;
  String _deviceType;
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  void deviceInfo() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Page(
        child: Container(
          margin: EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: Container(
            color: Colors.black.withOpacity(.5),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(
                          FontAwesomeIcons.puzzlePiece,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ADD DEVICE",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    buildTextField("product name", nameController),
                    buildTextField("Serial number", ssnController),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        //underline: Divider(color: Colors.white,),

                        isExpanded: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        value: _deviceType,

                        hint: Text(
                          "Gadget type",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(FontAwesomeIcons.mobile),
                        elevation: 30,
                        items: <DropdownMenuItem<String>>[
                          buildDropdownMenuItem("laptop"),
                          buildDropdownMenuItem("mobile"),
                          buildDropdownMenuItem("monitor"),
                          buildDropdownMenuItem("car"),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _deviceType = value;
                          });
                        },
                      ),
                    ),
                    //buildTextField("IMEI 1", imei1Controller),
                    //buildTextField("IMEI 2", imei2Controller),

                    buildConfirmButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildDropdownMenuItem(label) {
    return DropdownMenuItem(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      value: label,
    );
  }

  Container buildConfirmButton(context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        color: Colors.blue,
        child: Container(
          width: double.infinity,
          child: Center(child: Text("Confirm")),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: save,
      ),
    );
  }

  Padding buildTextField(label, controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          hintText: "Enter your" + label,
          labelText: label,
        ),
      ),
    );
  }

  void save() {
    String productName = nameController.text;
    String ssn = ssnController.text;
    String uid = _auth.currentUser.id;
    Device _device = Device(ssn,uid,productName,type:_deviceType);
    _auth.addDevice(_device);
  }
}
