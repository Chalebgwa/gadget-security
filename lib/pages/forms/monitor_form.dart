import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/widgets/nm_box.dart';

class MonitorForm extends StatelessWidget {
  MonitorForm({Key key}) : super(key: key);

  final TextEditingController _ssnController = TextEditingController();
  final TextEditingController _imeiController = TextEditingController();
  final TextEditingController _imei2Controller = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _manuController = TextEditingController();
  final TextEditingController _macController = TextEditingController();

  void save() {
    var ssn = _ssnController.text;
    var imei = _imeiController.text;
    var imei2 = _imei2Controller.text;
    var model = _modelController.text;
    var manufact = _manuController.text;
    var mac = _macController.text;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      fontSize: 40,
      color: Colors.white,
      fontWeight: FontWeight.w100,
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.7),
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: ListView(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.purple,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: CircleAvatar(
                        radius: 40,
                        child: Icon(FontAwesomeIcons.phone),
                      ),
                    ),
                  ),
                  _buildTextField(context, "manufacturer", _manuController),
                  _buildTextField(context, "model number", _modelController),
                  _buildTextField(context, "serial number", _ssnController),
                  _buildTextField(context, "imei", _imeiController),
                  _buildTextField(context, "imei 2", _imei2Controller),
                  _buildTextField(context, "mac address", _macController),
                  _buildSaveButton(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, hint, controller) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          suffixIcon: Icon(FontAwesomeIcons.userAlt),
          border: InputBorder.none,
          fillColor: Colors.lightBlueAccent,
          labelText: hint,
          labelStyle: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Container _buildSaveButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: nMbox.copyWith(boxShadow: []),
      child: FlatButton(
        onPressed: () {},
        child: Text(
          'Save',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
