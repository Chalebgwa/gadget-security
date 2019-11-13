import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/util/validator.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  final Auth auth;
  final VoidCallback onBlueClick;

  Registration({Key key, this.auth, this.onBlueClick}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _saveDevice = true;

  Auth _auth;
  DeviceProvider _deviceProvider;
  GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();

  Map<String, String> _deviceInfo = {};

  final TextEditingController _nameController = new TextEditingController();

  final TextEditingController _surnameController = new TextEditingController();

  final TextEditingController _emailController = new TextEditingController();

  final TextEditingController _passwordController = new TextEditingController();

  final TextEditingController _phoneController = new TextEditingController();

  final TextEditingController _gorvenmentIdController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _deviceProvider = Provider.of<DeviceProvider>(context);
  }

  Future<void> save() async {
    if (_registrationFormKey.currentState.validate()) {
      String _name = _nameController.text;
      String _surname = _surnameController.text;
      String _email = _emailController.text;
      String _gorvId = _gorvenmentIdController.text;
      String _password = _passwordController.text;
      String _phone = _phoneController.text;

      // register user before u register device
      // it would be safer to check if a user's device can register
      // but that has more problems than this approach
      String uid = await _auth.registerUser(
        _name,
        _surname,
        _email,
        _password,
        _phone,
        _gorvId,
      );


      // register device here
      if (_saveDevice && uid != null) {
        bool result = await _deviceProvider.savePrimaryDevice(_deviceInfo, uid);
        if (!result) {
          Fluttertoast.showToast(msg: "Device already exists");
        }
      } else if (uid == null) {
        Fluttertoast.showToast(msg: "user failed to register");
      }
    }
    //Navigator.pop(context);
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      color: Colors.black.withOpacity(.5),
      child: SingleChildScrollView(
        child: Form(
          key: _registrationFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildheader(),
              buildTextField("name", _nameController, Validator.validateName),
              buildTextField(
                  "surname", _surnameController, Validator.validateName),
              buildTextField("gorvernment id", _gorvenmentIdController,
                  Validator.validateIDNumber),
              buildTextField(
                  "phone", _phoneController, Validator.validateNumber),
              buildTextField(
                  "email", _emailController, Validator.validateEmail),
              buildTextField(
                  "password", _passwordController, Validator.validatePassword),
              buildDeviceInfo(),
              buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Row buildheader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              child: Icon(
                FontAwesomeIcons.solidArrowAltCircleLeft,
                color: Colors.blue,
              ),
              onPressed: widget.onBlueClick,
              backgroundColor: Colors.black,
            ),
          ),
        ),
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Registration",
                style: TextStyle(color: Colors.blue.shade100, fontSize: 30),
              ),
            ))
      ],
    );
  }

  Row buildDeviceInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _deviceInfo["model"] ?? "Device Name",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Card(
            color: Colors.transparent,
            child: CheckboxListTile(
              title: Text(
                "save device",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              activeColor: Colors.blue,
              selected: true,
              value: _saveDevice,
              onChanged: (bool value) {
                setState(() {
                  _saveDevice = value;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Container buildRegisterButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        color: Colors.blue,
        child: Container(
          width: double.infinity,
          child: Center(child: Text("Sign up")),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: save,
      ),
    );
  }

  Padding buildTextField(label, controller, validator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
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
}
