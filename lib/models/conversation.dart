import 'package:gsec/models/message.dart';
import 'package:gsec/models/user.dart';

class Conversation {
  final Client peer;
  final List<Message> messages;

  Conversation(this.peer, this.messages);
}
