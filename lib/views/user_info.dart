import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfo extends StatelessWidget {
  final Client user;
  const UserInfo({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            FontAwesomeIcons.user,
            color: Colors.purple,
          ),
          title: Text('${user.name} ${user.surname}'),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.phone, color: Colors.purple),
          title: Text(user.phone),
        ),
        ListTile(
          leading: Icon(
            Icons.email,
            color: Colors.purple,
          ),
          title: Text(
            user.email,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.location_city,
            color: Colors.purple,
          ),
          title: Text('${user.country}, ${user.city}'),
        ),
        Divider(),
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                launch("tel:${user.phone}");
              },
            ),
            FloatingActionButton(
              child: Icon(
                Icons.message,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                launch('sms:${user.phone}');
              },
            ),
            FloatingActionButton(
              child: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                launch('email:${user.email}');
              },
            ),
          ],
        ),
      ],
    );
  }

  Stack buildUserAvatar(Client user) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          key: Key("myImage"),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 35,
            backgroundColor: Theme.of(context).primaryColor,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: imageProvider,
            ),
          ),
          imageUrl: user.imageUrl ??
              "https://firebasestorage.googleapis.com/v0/b/gadget-security.appspot.com/o/user.png?alt=media&token=960f70f5-f741-46d3-998f-b33be09cbdf6",
          placeholder: (context, url) => Container(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ],
    );
  }
}
