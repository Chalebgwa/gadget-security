import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsec/models/message.dart';
import 'package:gsec/page.dart';

enum ChatType { GIF, IMAGE, TEXT, VIDEO }

class ChatView extends StatefulWidget {
  final int id;
  ChatView({Key key, this.id}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  final List<ChatItem> chats = [];
  final TextEditingController _controller = new TextEditingController();
  String image;
  bool isGifBlockOpen = false;
  FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        print(1);
        isGifBlockOpen = false;
      });
    }
  }

  handleSubmit(ChatType type, String content) {
    _controller.clear();
    focusNode.unfocus();
    setState(() {
      isGifBlockOpen = false;
    });
    //Message chat; //= new Message(null, null, null, null, null);

    //var chatItem = ChatItem(
    //  chat: chat,
    //  animationController: AnimationController(
    //    vsync: this,
    //    duration: Duration(milliseconds: 1000),
    //  ),
    //);

    setState(() {
      //chats.insert(0, chatItem);
    });
    //chatItem.animationController.forward();
  }

  getImage() async {
    var file;
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      child: Flex(
        direction: Axis.vertical,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
              flex: 4,
              child: Container(
                child: ListView.builder(
                  reverse: true,
                  itemCount: chats.length,
                  itemBuilder: (_, index) {
                    return chats[index];
                  },
                ),
              )),
          Container(
            color: Colors.white.withOpacity(0.6),
            child: IconTheme(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.image),
                    onPressed: () {
                      focusNode.unfocus();
                      setState(() {
                        isGifBlockOpen = false;
                      });
                      getImage();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.gif),
                    onPressed: () {
                      focusNode.unfocus();
                      setState(() {
                        isGifBlockOpen = !isGifBlockOpen;
                      });
                    },
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        focusNode: focusNode,
                        controller: _controller,
                        onSubmitted: (text) {
                          handleSubmit(ChatType.TEXT, text);
                        },
                        decoration: InputDecoration(
                            //isDense: true,
                            contentPadding:
                                EdgeInsets.only(bottom: 10, top: 10, left: 10),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Type Message",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      handleSubmit(ChatType.TEXT, _controller.text);
                    },
                  )
                ],
              ),
              data: IconThemeData(color: Colors.white),
            ),
          ),
          isGifBlockOpen ? buildGifBock() : Container()
        ],
      ),
    );
  }

  buildGifItem(String name) {
    var gif = "gifs/$name";
    return InkWell(
      child: Container(
        height: 100,
        width: 100,
        child: Image.asset(gif),
      ),
      onTap: () {
        handleSubmit(ChatType.GIF, gif);
      },
    );
  }

  buildGifBock() {
    return Container(
      height: 200,
      //color: Colors.blue,
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (_, index) => buildGifItem("mimi${index + 1}.gif"),
        itemCount: 9,
      ),
    );
  }

  @override
  void dispose() {
    for (var item in chats) {
      item.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatItem extends StatelessWidget {
  final AnimationController animationController;
  final Message chat;
  const ChatItem({Key key, this.animationController, this.chat})
      : super(key: key);

  getType() {
    switch (chat.type) {
      case MessageType.TEXT:
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 3,
            color: Colors.green,
            child: Container(
              margin: EdgeInsets.all(20),
              child: Text(
                chat.content,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      case MessageType.IMAGE:
        var file = File(chat.content);
        return Card(
          child: Container(
            height: 300,
            child: Image(
              image: FileImage(file),
            ),
          ),
        );

      case MessageType.GIF:
        return Container(
          height: 100,
          child: Image.asset(chat.content),
        );
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var time = chat.timestamp;

    return SizeTransition(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getType(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceInOut,
      ),
    );
  }
}
