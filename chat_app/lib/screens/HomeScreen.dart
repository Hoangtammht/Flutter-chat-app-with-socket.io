import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/NewScreen/call_screen.dart';
import 'package:chat_app/pages/CameraPage.dart';
import 'package:chat_app/pages/ChatPage.dart';
import 'package:chat_app/pages/StatusPage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<ChatModel> chatModels;
  final ChatModel sourceChat;
  const HomeScreen({Key? key, required this.chatModels, required this.sourceChat}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Whatsapp Clone'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton<String>(
              onSelected: (value){
                print(value);
              },
              itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("New group"),
                value: "New group",
              ),
              PopupMenuItem(
                child: Text("New broadcast"),
                value: "New broadcast",
              ),
              PopupMenuItem(
                child: Text("Whatsapp Web"),
                value: "Whatsapp Web",
              ),
              PopupMenuItem(
                child: Text("Starred messages"),
                value: "Starred messages",
              ),
              PopupMenuItem(
                child: Text("Settings"),
                value: "Settings",
              )
            ];
          }),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              text: 'CHATS',
            ),
            Tab(
              text: 'STATUS',
            ),
            Tab(
              text: 'CALLS',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          CameraPage(),
          ChatPage(chatmodels: widget.chatModels,
          sourceChat: widget.sourceChat,
          ),
          StatusPage(),
          CallScreen(),
        ],
      ),
    );
  }
}
