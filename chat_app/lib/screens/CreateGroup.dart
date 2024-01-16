import 'package:chat_app/CustomUI/AvatarCard.dart';
import 'package:chat_app/CustomUI/ContactCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ChatModel> contacts = [
    ChatModel(name: 'Dev Stack', status: 'A full stack developer'),
    ChatModel(name: 'Balram', status: 'Flutter developer'),
    ChatModel(name: 'Saket', status: 'developer'),
    ChatModel(name: 'Dev', status: 'App developer'),
    ChatModel(name: 'Kirosh', status: 'A full stack developer'),
    ChatModel(name: 'Tester', status: 'Flutter developer'),
    ChatModel(name: 'Designer', status: 'developer'),
    ChatModel(name: 'KY', status: 'App developer'),
    ChatModel(name: 'HT', status: 'A full stack developer'),
    ChatModel(name: 'Helper', status: 'Analysis developer'),
    ChatModel(name: 'BA', status: 'Analysis'),
    ChatModel(name: 'DA', status: 'Analysis'),
  ];

  List<ChatModel> groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Group',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                'Add participants',
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  size: 26,
                )),
          ],
        ),
        body: Stack(children: [
          ListView.builder(
              itemCount: contacts.length + 1,
              itemBuilder: (context, index) {
                if(index == 0) {
                  return Container(
                    height: groups.length > 0 ? 90 : 10,
                  );
                }
                return InkWell(
                    onTap: () {
                      if (contacts[index-1].select == false) {
                        setState(() {
                          contacts[index-1].select = true;
                          groups.add(contacts[index-1]);
                        });
                      } else {
                        setState(() {
                          contacts[index-1].select = false;
                          groups.remove(contacts[index-1]);
                        });
                      }
                      print(groups);
                    },
                    child: ContactCard(contact: contacts[index-1]));
              }),
          groups.length > 0 ? Column(
            children: [
              Container(
                height: 75,
                color: Colors.white,
                child: ListView.builder(
                    itemCount: contacts.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if(contacts[index].select == true){
                        return InkWell(
                            onTap: (){
                              setState(() {
                                groups.remove(contacts[index]);
                                contacts[index].select = false;
                              });
                            },
                            child: AvatarCard(contact: contacts[index]));
                      }else{
                        return Container();
                      }
                    }),
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ) : Container()
        ]));
  }
}
