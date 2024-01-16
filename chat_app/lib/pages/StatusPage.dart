import 'package:chat_app/CustomUI/StatusPage/HeadOwnStatus.dart';
import 'package:chat_app/CustomUI/StatusPage/OthersStatus.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 48,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[100],
              elevation: 8,
              onPressed: () {},
              child: Icon(Icons.edit, color: Colors.blueGrey[900]),
            ),
          ),
          SizedBox(
            height: 13,
          ),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.greenAccent[700],
            elevation: 5,
            child: Icon(Icons.camera_alt),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const SizedBox(height: 10,),
            HeadOwnStatus(),
            label("Recent Update"),
            Container(
              height: 33,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              child: Text(
                "Recent Updates",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            OthersStatus(
              name: 'Bamrald thomem',
              time: '01:56',
              imageName: "assets/2.jpeg",
              isSeen: true,
              statusNum: 1,
            ),
            OthersStatus(
              name: 'Lisa',
              time: '01:26',
              imageName: "assets/2.jpeg",
              isSeen: true,
              statusNum: 2,
            ),
            OthersStatus(
              name: 'May',
              time: '03:56',
              imageName: "assets/2.jpeg",
              isSeen: false,
              statusNum: 3,
            ),
            SizedBox(height: 10,),
            label('Viewed updates'),
            OthersStatus(
              name: 'Bamrald thomem',
              time: '01:56',
              imageName: "assets/2.jpeg",
              isSeen: true,
              statusNum: 1,
            ),
            OthersStatus(
              name: 'Lisa',
              time: '01:26',
              imageName: "assets/2.jpeg",
              isSeen: true,
              statusNum: 2,
            ),
            OthersStatus(
              name: 'May',
              time: '03:56',
              imageName: "assets/2.jpeg",
              isSeen: true,
              statusNum: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget label(String labelName) {
    return Container(
      height: 33,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Text(
          labelName,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
