import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/widgets/device_card.dart';

class TradeView extends StatelessWidget {
  const TradeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/back.jpg"), fit: BoxFit.fill),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(.8),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildAvatar(),
                            Icon(FontAwesomeIcons.angleDoubleRight),
                            _buildAvatar(),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        endIndent: 10,
                        indent: 10,
                      ),
                      DeviceCard(),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: "Peer ID",
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white.withOpacity(.5),
                                    filled: true),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.white.withOpacity(.5),
                                  filled: true,
                                ),
                              ),
                            ),
                            OutlineButton(
                              onPressed: () {},
                              borderSide: BorderSide(
                                color: Colors.white,
                                style: BorderStyle.solid,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                width: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 50,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                child: Icon(FontAwesomeIcons.user),
              ),
            ),
          ),
        ),
        Text(
          "Person Surname",
          style: TextStyle(color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            "77147912",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            "72 801 8011",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
