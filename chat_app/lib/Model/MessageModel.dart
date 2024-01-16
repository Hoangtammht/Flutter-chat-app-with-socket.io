class MessageModel {
  int ?sender;
  int ?received;
  String type;
  String message;
  String time;
  String path;
  MessageModel({
    this.sender, this.received, required this.type, required this.message, required this.time, required this.path
  });
}