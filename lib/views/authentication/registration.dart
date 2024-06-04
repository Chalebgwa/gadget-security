import 'dart:ui';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/providers/device_provider.dart';
import 'package:gsec/util/validator.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/bloc/simple_hidden_drawer_bloc.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  final Auth auth;
  final VoidCallback onBlueClick;

  Registration(
      {Key key, this.auth, this.onBlueClick, SimpleHiddenDrawerBloc controller})
      : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _saveDevice = true;

  Auth _auth;
  DeviceProvider _deviceProvider;
  String _deviceName;
  String _deviceId;
  String _countryCode = "+267";

  GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _deviceProvider = Provider.of<DeviceProvider>(context);
    _deviceName = _deviceProvider.details['model'];
    _deviceId = _deviceProvider.details['identifier'];
  }

  Future<void> save() async {
    if (_registrationFormKey.currentState.validate()) {
      String _name = _nameController.text;
      String _surname = _surnameController.text;
      String _email = _emailController.text;
      String _gorvId = _gorvenmentIdController.text;
      String _password = _passwordController.text;
      String _phone = _countryCode + _phoneController.text;

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
      if (_saveDevice) {
        bool result = await _deviceProvider.savePrimaryDevice(uid);
        if (!result) {
          Fluttertoast.showToast(msg: "Device already exists");
        }
      } else if (uid == null) {
        Fluttertoast.showToast(msg: "user failed to register");
      }
    }
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      //
      child: Form(
        key: _registrationFormKey,
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //buildheader(),
            Container(
              margin: EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              color: Theme.of(context).primaryColor.withOpacity(.4),
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text('User Details'),
                    ),
                  ),
                  buildTextField(
                    "name",
                    _nameController,
                    Validator.validateName,
                    'name',
                  ),
                  buildTextField("surname", _surnameController,
                      Validator.validateName, 'surname'),
                  buildTextField(
                    "Legal Identification number",
                    _gorvenmentIdController,
                    Validator.validateIDNumber,
                    '000000000',
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor.withOpacity(.4),
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text('Security Details'),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CountryCodePicker(
                            onChanged: (cc) {
                              setState(() {
                                _countryCode = cc.dialCode;
                              });
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'BW',
                            favorite: ['+267', 'BW'],

                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: buildTextField(
                          "phone",
                          _phoneController,
                          Validator.validateNumber,
                          'eg 77777777',
                        ),
                      ),
                    ],
                  ),
                  buildTextField(
                    "email",
                    _emailController,
                    Validator.validateEmail,
                    'email',
                  ),
                  buildTextField("password", _passwordController,
                      Validator.validatePassword, 'password'),
                ],
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor.withOpacity(.4),
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text('Device Details'),
                    ),
                  ),
                  buildDeviceInfo(),
                ],
              ),
            ),
            buildRegisterButton(),
          ],
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
              heroTag: 'blue',
              child: Icon(
                FontAwesomeIcons.solidArrowAltCircleLeft,
                color: Colors.purple,
              ),
              onPressed: widget.onBlueClick,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Registration",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                    fontFamily: 'pacifico'),
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
              _deviceName ?? "Device Name",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: CheckboxListTile(
            checkColor: Colors.purple,
            title: Text(
              "save device",
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).primaryColor,
              ),
            ),
            activeColor: Theme.of(context).primaryColor,
            selected: true,
            value: _saveDevice,
            onChanged: (bool value) {
              setState(() {
                _saveDevice = value;
              });
            },
          ),
        )
      ],
    );
  }

  Container buildRegisterButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Container(
          width: double.infinity,
          child: Center(child: Text("Sign up")),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: save,
      ),
    );
  }

  Padding buildTextField(label, controller, validator, hint, {isPhone = true}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        decoration: InputDecoration(
          labelStyle:
              TextStyle(color: Theme.of(context).accentColor.withOpacity(.6)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
            ),
          ),
          hintText: hint,
          hintStyle:
              TextStyle(color: Theme.of(context).accentColor, fontSize: 10.0),
          labelText: label,
        ),
      ),
    );
  }
}
