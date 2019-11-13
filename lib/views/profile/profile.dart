import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/device.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:gsec/widgets/device_card.dart';

import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static Random random = Random();
  Auth _auth;
  User _currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
    _currentUser = _auth.currentUser;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: buildHomeView(context),
    );
  }

  Widget buildHomeView(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          //color: Colors.black.withOpacity(.4),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: buildUserAvatar(),
                    ),
                    Expanded(
                      child: Text(
                        _currentUser?.name ?? "No name",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                //SizedBox(height: 3),

                //SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //buildInboxButton(),
                    buildAddButton(context),
                    buildEditProfile(),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("devices")
                        .where("ownerId", isEqualTo: _auth.currentUser.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return Center(
                        child: !snapshot.hasData //_devices.isEmpty
                            ? Text(
                                "No registered devices",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                primary: false,
                                padding: EdgeInsets.all(5),
                                itemCount: snapshot
                                    .data.documents.length, //_devices.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot shot =
                                      snapshot.data.documents[index];

                                  return new DeviceCard(
                                    device: Device.fromMap(shot.data),
                                  );
                                },
                              ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildEditProfile() {
    return Container(
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          FontAwesomeIcons.userEdit,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/editProfile");
        },
      ),
    );
  }

  RaisedButton buildAddButton(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
      color: Colors.white,
      onPressed: () {
        Navigator.pushNamed(context, "/addDevice");
      },
    );
  }

  Stack buildInboxButton() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              FontAwesomeIcons.exchangeAlt,
              color: Colors.black,
            ),
            color: Colors.grey.shade200,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    //builder: (context) => Inbox(),
                    ),
              );
            },
          ),
        ),
        Positioned(
          right: 2,
          top: 9,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              "34",
              style: TextStyle(color: Colors.white),
            ),
            radius: 15,
          ),
        ),
      ],
    );
  }

  Stack buildUserAvatar() {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          key: Key("myImage"),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 40,
            backgroundImage: imageProvider,
          ),
          imageUrl: _currentUser?.imageUrl ??
              "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6",
          placeholder: (context, url) => Container(child: CircularProgressIndicator(),),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ],
    );
  }
}