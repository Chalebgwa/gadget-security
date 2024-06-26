import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:ui';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final Auth auth;
  final VoidCallback onBlueClick;

  EditProfile({Key key, this.auth, this.onBlueClick}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File image;
  Auth _auth;
  Client _currentUser;
  bool _isLoadingImage = false;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  TextEditingController _middlenameController = new TextEditingController();
  TextEditingController _idController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _currentUser = _auth.currentUser;

    _nameController.text = _currentUser?.name ?? "";
    _surnameController.text = _currentUser?.surname ?? "";

    _idController.text = _currentUser?.gorvenmentId ?? "";

    _emailController.text = _currentUser?.email ?? "";
    _phoneController.text = _currentUser?.phone ?? "";

    _cityController.text = _currentUser?.city ?? "";
    _countryController.text = _currentUser?.country ?? "";
  }

  void pickImageGallery() async {
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);

    file = await _cropImage(file);
    setState(() {
      image = file;
    });
    Navigator.pop(context);
    await upload(image);
  }

  void pickImageCamera() async {
    var file = await ImagePicker.pickImage(source: ImageSource.camera);

    file = await _cropImage(file);
    setState(() {
      image = file;
    });
    Navigator.pop(context);
    await upload(image);
  }

  void showPickerOptions() {
    showModalBottomSheet(
        builder: (BuildContext context) {
          return ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(FontAwesomeIcons.image),
                  onPressed: pickImageGallery),
              IconButton(
                  icon: Icon(FontAwesomeIcons.camera),
                  onPressed: pickImageCamera),
            ],
          );
        },
        context: context);
  }

  Future<void> upload(File image) async {
    await _auth.uploadFile(image);
    setState(() {
      _isLoadingImage = false;
    });
    Fluttertoast.showToast(msg: "Image uploaded");
  }

  Future<File> _cropImage(File file) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Theme.of(context).accentColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    return croppedFile;
    return file;
  }

  void save() async {
    var _name = _nameController.text;
    var _surname = _surnameController.text;
    var _middleName = _middlenameController.text;
    var _id = _idController.text;
    var _phone = _phoneController.text;
    var _email = _emailController.text;
    var _city = _cityController.text;
    var _country = _countryController.text;
    var _imageUrl = _auth.currentUser.imageUrl;

    _auth.updateUser(
      city: _city,
      country: _country,
      email: _email,
      idNumber: _id,
      phone: _phone,
      userId: _currentUser.id,
      middlename: _middleName,
      name: _name,
      surname: _surname,
      imageUrl: _imageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _globalKey,
        body: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            InkWell(
              onTap: showPickerOptions,
              child: Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                alignment: Alignment.center,
                child: buildUserAvatar(),
              ),
            ),
            buildUserDetailsCard(),
            buildContantDetailsCard(),
            buildLocationDetailsCard(),
            RaisedButton(
              onPressed: save,
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLocalImage() {
    return CircleAvatar(
      radius: 40,
      backgroundImage: FileImage(image),
    );
  }

  Widget buildUserDetailsCard() {
    return ListBody(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: ListTileTheme(
            style: ListTileStyle.list,
            child: ListTile(
              title: Text(
                "User Details",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            buildTextField("name", _nameController),
            buildTextField("surname", _surnameController),
            buildTextField("id number", _idController),
          ],
        ),
        Divider(
          height: 30,
        )
      ],
    );
  }

  Widget buildLocationDetailsCard() {
    return ListBody(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: ListTileTheme(
            style: ListTileStyle.list,
            child: ListTile(
              title: Text(
                "Location",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            buildTextField("city", _cityController),
            buildTextField("country", _countryController),
          ],
        ),
        Divider(
          height: 30,
        )
      ],
    );
  }

  Widget buildContantDetailsCard() {
    return ListBody(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: ListTileTheme(
            style: ListTileStyle.list,
            child: ListTile(
              title: Text(
                "Contacts",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            buildTextField("email", _emailController),
            buildTextField("phone", _phoneController),
          ],
        ),
        Divider(
          height: 30,
        )
      ],
    );
  }

  Widget buildTextField(label, controller) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(.5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Theme.of(context).accentColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor),
            ),
            hintText: "Enter your" + label,
            labelText: label,
          ),
        ),
      ),
    );
  }

  Widget buildUserAvatar() {
    if (!_isLoadingImage) {
      return Stack(
        children: <Widget>[
          CachedNetworkImage(
            key: Key("myImage"),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 45,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: imageProvider,
              ),
            ),
            imageUrl: _currentUser?.imageUrl ??
                "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6",
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Icon(
            FontAwesomeIcons.camera,
            color: Colors.purple,
          )
        ],
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
