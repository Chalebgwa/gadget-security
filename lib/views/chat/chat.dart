import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/user.dart';
import 'package:gsec/page.dart';
import 'package:gsec/views/chat/chatView.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key key}) : super(key: key);

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final GlobalKey<AnimatedListState> _globalKey =
      GlobalKey<AnimatedListState>();

  Tween<Offset> tween = new Tween<Offset>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  showUsers() {
    showCupertinoModalPopup(
        builder: (BuildContext context) {
          return Container(
            child: ListView.builder(
              itemCount: 10,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Client user = Client.users[index];
                return Card(
                  child: ListTile(
                    title: Text(user.name),
                    onTap: () {},
                  ),
                );
              },
            ),
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showUsers,
        child: Icon(FontAwesomeIcons.feather),
      ),
      body: Page(
          child: AnimatedList(
        key: _globalKey,
        initialItemCount: 10,
        itemBuilder: (BuildContext context, int index, Animation animation) {
          return FadeTransition(
            child: buildChatHeader(index),
            opacity: animation,
          );
        },
      )),
    );
  }

  void openChat() {
    var route = MaterialPageRoute(builder: (context) => ChatView());
    Navigator.push(context, route);
  }

  void remove(int i) {
    _globalKey.currentState.removeItem(
      i,
      (context, animation) => buildChatHeader(i),
    );
  }

  Widget buildChatHeader(int i) {
    return Card(
      color: Colors.white.withOpacity(0.5),
      child: ListTile(
        onLongPress: () {
          remove(i);
        },
        onTap: openChat,
        leading: CircleAvatar(
          child: Text("R"),
          //backgroundColor: Colors.white.withOpacity(0.1),
        ),
        title: Text("David Ntombeni"),
        subtitle: Text("hello my old friend, how are you?"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("12:01"),
            Icon(
              FontAwesomeIcons.check,
              size: 10,
            ),
          ],
        ),
      ),
    );
  }
}
