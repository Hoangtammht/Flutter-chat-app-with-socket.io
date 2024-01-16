import 'package:chat_app/CustomUI/CustomCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/screens/SelectContact.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final List<ChatModel> chatmodels;
  final ChatModel sourceChat;
  const ChatPage({Key? key,  required this.chatmodels, required this.sourceChat}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectContact()));
        },
        child: Icon(Icons.chat),
      ),
      body: ListView.builder(
          itemCount: widget.chatmodels.length,
          itemBuilder: (context, index){
            return CustomCard(
              chatModel: widget.chatmodels[index],
              sourceChat: widget.sourceChat,
            );
          })
    );
  }
}
