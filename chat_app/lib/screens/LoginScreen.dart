import 'package:chat_app/CustomUI/ButtonCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ChatModel sourceChat;

  List<ChatModel> chats = [
    ChatModel(
        id: 1,
        name: 'Dev Stack',
        icon: 'person.svg',
        isGroup: false,
        time: "4:00",
        currentMessage: "Hi EveryOne"),
    ChatModel(
        id: 2,
        name: 'Kishor',
        icon: 'person.svg',
        isGroup: false,
        time: "10:00",
        currentMessage: "Hi Kishor"),
    ChatModel(
        id: 3,
        name: 'Collins',
        icon: 'person.svg',
        isGroup: false,
        time: "10:00",
        currentMessage: "Hi Dev Stack"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: (){
                 sourceChat = chats.removeAt(index);
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                   HomeScreen(
                     chatModels: chats,
                      sourceChat: sourceChat,
                   )
                 ));
                },
                child: ButtonCard(name: chats[index].name, icon: Icons.person));
          }),
    );
  }
}
