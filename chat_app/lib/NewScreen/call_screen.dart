import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          callCard("Dev Stack", Icons.call_made, Colors.green, "July 18, 18:36"),
          callCard("Hoang tam", Icons.call_missed, Colors.red, "July 19, 18:36"),
          callCard("KY", Icons.call_received, Colors.green, "July 19, 18:36"),
          callCard("Kust", Icons.call_made, Colors.green, "July 18, 18:36"),
          callCard("Dev Stack", Icons.call_made, Colors.green, "July 18, 18:36"),
          callCard("Hoang tam", Icons.call_missed, Colors.red, "July 19, 18:36"),
          callCard("KY", Icons.call_received, Colors.green, "July 19, 18:36"),
          callCard("Kust", Icons.call_made, Colors.green, "July 18, 18:36"),
          callCard("Dev Stack", Icons.call_missed, Colors.red, "July 18, 18:36"),
          callCard("Hoang tam", Icons.call_missed, Colors.red, "July 19, 18:36"),
          callCard("KY", Icons.call_received, Colors.green, "July 19, 18:36"),
          callCard("Kust", Icons.call_missed, Colors.red, "July 18, 18:36"),
        ],
      ),
    );
  }

  Widget callCard(String name, IconData iconData, Color iconColor, String time){


    return Card(
      margin: EdgeInsets.only(bottom: 0.5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
        ),
        title: Text(name, style: TextStyle(
          fontWeight: FontWeight.w500,
        ),),
        subtitle: Row(
          children: [
            Icon(iconData, color: iconColor, size: 20,),
            SizedBox(width: 6,),
            Text(time, style: TextStyle(
              fontSize: 12.8,
            ),),
          ],
        ),
        trailing: Icon(Icons.call, size: 28, color: Colors.teal,),
      ),
    );
  }

}
