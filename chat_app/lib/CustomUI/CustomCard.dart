import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/screens/IndividualPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  final ChatModel chatModel;
  final ChatModel sourceChat;
  const CustomCard(
      {Key? key, required this.chatModel, required this.sourceChat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IndividualPage(
                      chatModel: chatModel,
                      sourceChat: sourceChat,
                    )));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: SvgPicture.asset(
                chatModel.isGroup ?? false
                    ? "assets/groups.svg"
                    : "assets/person.svg",
                color: Colors.white,
                height: 38,
                width: 38,
              ),
              backgroundColor: Colors.blueGrey,
            ),
            title: Text(
              chatModel.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  chatModel.currentMessage ?? "Unknown",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(chatModel.time ?? "Unknown"),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
