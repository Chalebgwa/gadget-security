import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:gsec/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserSelector extends StatefulWidget {
  UserSelector({Key key}) : super(key: key);

  _UserSelectorState createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  Auth _auth;
  String field;
  TextEditingController _controller = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<Auth>(context);
  }

  Future<void> onSubmit(String value) async {
    User user = await _auth.userProvider.fetchUser("gorvenmentId", value);
    if (user != null) {
      //Navigator.pop(context, user);
      bool ok = false;
      await AwesomeDialog(
          useRootNavigator: false,
          btnOkOnPress: () {
            setState(() {
              ok = true;
            });
          },
          context: context,
          animType: AnimType.BOTTOMSLIDE,
          btnCancel: FlatButton(
            child: Icon(Icons.close),
            onPressed: () {
              setState(() {
                ok = false;
              });
              Navigator.pop(context);
            },
            color: Theme.of(context).accentColor,
          ),
          btnOk: FlatButton(
            child: Icon(Icons.check_circle),
            onPressed: () {
              setState(() {
                ok = true;
              });
              Navigator.pop(context);
            },
            color: Theme.of(context).accentColor,
          ),
          btnOkColor: Colors.purple,
          btnCancelColor: Colors.blue,
          desc: "Confirm User",
          customHeader: CachedNetworkImage(
            imageBuilder: (context, provider) {
              return CircleAvatar(
                radius: 40,
                backgroundImage: provider,
              );
            },
            placeholder: (context, s) {
              return CircleAvatar(
                child: Icon(FontAwesomeIcons.question),
              );
            },
            imageUrl: user.imageUrl,
          ),
          body: IconTheme(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text("${user.name}"),
                ),
                ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text("${user.surname}"),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text("${user.email}"),
                ),
              ],
            ),
            data: IconThemeData(color: Colors.purple),
          )).show();
      if (ok) {
        Navigator.pop(context, user);
      }
    } else {
      Fluttertoast.showToast(msg: "User does not exist");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      primary: true,
          body: Column(
            
        //direction: Axis.vertical,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            onSubmitted: onSubmit,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter User ID",
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          RaisedButton(
                child: Text("Search"),
                onPressed: () {
                  onSubmit(_controller.text);
                })
        ],
      ),
    );
  }

  void pickUser() {}
}

class UserCard extends StatelessWidget {
  const UserCard({Key key, this.user, this.callback}) : super(key: key);
  final VoidCallback callback;

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.name),
        onTap: callback,
      ),
    );
  }
}
