import 'package:flutter/material.dart';
import 'package:gsec/models/conversation.dart';
import 'package:gsec/models/user.dart';

class ChatProvider extends ChangeNotifier {
  List<Conversation> _chats = [];
  List<Conversation> get chats => _chats;


  void initChats(){
    
  }

  void createChat(User user, User peer) {
    String chatId = peer.id;
    if (_chats.any((e) => e.peer.id == chatId)) {
      return;
    }

    // todo :fetch convo data
    Conversation conversation = new Conversation(peer, []);
    _chats.add(conversation);
    notifyListeners();
  }
}
