import 'package:flutter/material.dart';
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
    User user = await _auth.userProvider.fetchUser(field, value);
    Navigator.pop(context, user);
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: Center(
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              hint: Text("Search with.."),
              onChanged: (String value) {
                setState(() {
                  field = value;
                });
              },
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  child: Text("Gorvernment issued id"),
                  value: "gorvermentId",
                ),
                DropdownMenuItem(
                  child: Text("Email"),
                  value: "email",
                ),
                DropdownMenuItem(
                  child: Text("Phone"),
                  value: "phone",
                ),
              ],
            ),
            TextField(
              controller: _controller,
              onSubmitted: onSubmit,
              enabled: field != null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Search User"),
            ),
            RaisedButton(
              child: Text("Search"),
              onPressed: field!=null ? () {
                onSubmit(_controller.text);
              } : null,
            )
          ],
        ),
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
