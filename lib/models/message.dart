enum MessageType { GIF, VIDEO, TEXT, IMAGE }

class Message {
  final String content;
  final MessageType type;
  final String timestamp;

  Message(this.content, this.type, this.timestamp);
  
}
