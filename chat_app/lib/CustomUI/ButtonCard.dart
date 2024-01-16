import 'package:flutter/material.dart';

import 'package:chat_app/Model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonCard extends StatelessWidget {
  final String name;
  final IconData icon;

  const ButtonCard({Key? key, required this.name, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        child: Icon(
          icon,
          size: 26,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF25D366),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
