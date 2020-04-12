import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  AboutUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Developer",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/d2.jpeg"),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "vdjhbs febyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwh fefwbfeyegyf ehfyewgyf evgfge egfewd avde fedeva ywadvevf agyugdeueuewv uwguwgev uawugdwfd wvetvfe ytre wvftefe6 yavwyewt",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/d2.jpeg"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Developer",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "vdjhbs febyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwh fefwbfeyegyf ehfyewgyf evgfge egfewd avde fedeva ywadvevf agyugdeueuewv uwguwgev uawugdwfd wvetvfe ytre wvftefe6 yavwyewt",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Developer",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/d2.jpeg"),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "vdjhbs febyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwhfebyhfiwh fefwbfeyegyf ehfyewgyf evgfge egfewd avde fedeva ywadvevf agyugdeueuewv uwguwgev uawugdwfd wvetvfe ytre wvftefe6 yavwyewt",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
