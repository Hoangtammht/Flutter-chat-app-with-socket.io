import 'dart:convert';
import 'dart:io';

import 'package:chat_app/CustomUI/OwnFileCard.dart';
import 'package:chat_app/CustomUI/OwnMessage.dart';
import 'package:chat_app/CustomUI/ReplyCard.dart';
import 'package:chat_app/CustomUI/ReplyFileCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Model/MessageModel.dart';
import 'package:chat_app/screens/CameraScreen.dart';
import 'package:chat_app/screens/CameraView.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class IndividualPage extends StatefulWidget {
  final ChatModel chatModel;
  final ChatModel sourceChat;
  const IndividualPage(
      {Key? key, required this.chatModel, required this.sourceChat})
      : super(key: key);

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  late IO.Socket socket;
  TextEditingController _controller = TextEditingController();
  bool sendButton = false;
  List<MessageModel> messages = [];
  ScrollController _scrollController = ScrollController();
  ImagePicker _picker = ImagePicker();
  late XFile file;
  int popTime = 0;
  bool isMe = false;

  @override
  void initState() {
    super.initState();
    connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  void connect() {
    socket = IO.io("http://192.168.36.81:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("signin", widget.sourceChat.id);
    socket.onConnect((data) {
      print("Connected");
      socket.emit("load_messages", {
        "sourceId": widget.sourceChat.id,
        "targetId": widget.chatModel.id,
      });

      socket.on("message", (msg) {
        print(msg);
        setMessage(msg["sender"], msg["received"], 'destination', msg["message"], msg["path"]);
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
    print(socket.connected);
    socket.on("loaded_messages", (messages) {
      messages.forEach((msg) {
        if(widget.sourceChat.id == msg["sender"]){
          setState(() {
            isMe = true;
          });
        }else{
          setState(() {
            isMe = false;
          });
        }
        setMessage(msg["sender"], msg["received"],'destination', msg["message"], msg["path"]);
      });
    });
  }

  void sendMessage(String message, int sourceId, int targetId, String path) async {
    setMessage(sourceId, targetId, "source", message, path);

    final response = await http.post(
      Uri.parse('http://192.168.36.81:5000/routes/addmessage'), // Địa chỉ API Node.js để lưu tin nhắn
      body: {
        'sourceId': sourceId.toString(),
        'targetId': targetId.toString(),
        'message': message,
        'path': path,
      },
    );

    if (response.statusCode == 200) {
      print('Message sent and saved to MongoDB');
    } else {
      print('Error sending message to server');
    }

    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
      "path": path
    });

  }

  void setMessage(int sender, int received, String type, String message, String path) {

    MessageModel messageModel = MessageModel(
        sender: widget.sourceChat.id,
        received: widget.chatModel.id,
        type: type,
        message: message,
        path: path,
        time: DateTime.now().toString().substring(10, 16));
    setState(() {
      setState(() {
        messages.add(messageModel);
      });
    });
  }

  void onImageSend(String path, String message) async {
    for (int i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });

    var request = http.MultipartRequest(
        "POST", Uri.parse("http://192.168.1.119:5000/routes/addimage"));
    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    print(data['path']);
    print(response.statusCode);
    setMessage(widget.sourceChat?.id ?? -1, widget.chatModel?.id ?? -1, "source", message, path);
    socket.emit("message", {
      "message": messages,
      "sourceId": widget.sourceChat.id,
      "targetId": widget.chatModel.id,
      "path": data['path']
    });

    var messageData = {
      "message": message,
      "sourceId": widget.sourceChat.id,
      "targetId": widget.chatModel.id,
      "path": data['path'],
    };

    var messageSendResponse = await http.post(
      Uri.parse("http://192.168.1.119:5000/routes/addmessage"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(messageData),
    );

    if (messageSendResponse.statusCode == 200) {
      print("Message sent successfully");
      setMessage(widget.sourceChat?.id ?? -1, widget.chatModel?.id ?? -1,"source", message, data['path']);
      socket.emit("message", messageData);
    } else {
      print("Failed to send message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets/whatsapp_back.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leadingWidth: 70,
          titleSpacing: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                  child: SvgPicture.asset(
                    widget.chatModel.isGroup ?? false
                        ? "assets/groups.svg"
                        : "assets/person.svg",
                    color: Colors.white,
                    height: 36,
                    width: 36,
                  ),
                )
              ],
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatModel.name,
                    style: TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'last seen today at 12:05',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
            IconButton(onPressed: () {}, icon: Icon(Icons.call)),
            PopupMenuButton<String>(onSelected: (value) {
              print(value);
            }, itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("View Contact"),
                  value: "View Contact",
                ),
                PopupMenuItem(
                  child: Text("Media, links, and docs"),
                  value: "Media, links, and docs",
                ),
                PopupMenuItem(
                  child: Text("Whatsapp Web"),
                  value: "Whatsapp Web",
                ),
                PopupMenuItem(
                  child: Text("Search"),
                  value: "Search",
                ),
                PopupMenuItem(
                  child: Text("Mute Notification"),
                  value: "Mute Notification",
                ),
                PopupMenuItem(
                  child: Text("Wallpaper"),
                  value: "Wallpaper",
                )
              ];
            }),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WillPopScope(
            child: Column(
              children: [
                Expanded(
                  // height: MediaQuery.of(context).size.height - 165,
                  child:
                  ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return Container(
                          height: 70,
                        );
                      }

                      final message = messages[index];

                        if (message.type == "source") {
                          if (message.path.length > 0) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: OwnFileCard(
                                path: message.path,
                                message: message.message,
                                time: message.time,
                              ),
                            );
                          }else {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: OwnMessageCard(
                                message: message.message,
                                time: message.time,
                              ),
                            );
                        }
                      } else{
                        if (message.path.length > 0) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: ReplyFileCard(
                              path: message.path,
                              message: message.message,
                              time: message.time,
                            ),
                          );
                        } else {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: ReplyCard(
                              message: message.message,
                              time: message.time,
                            ),
                          );
                        }
                      }


                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                    margin: EdgeInsets.only(
                                        left: 2, right: 2, bottom: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        if (value.length > 0) {
                                          setState(() {
                                            sendButton = true;
                                          });
                                        } else {
                                          setState(() {
                                            sendButton = false;
                                          });
                                        }
                                      },
                                      controller: _controller,
                                      focusNode: focusNode,
                                      maxLines: 5,
                                      minLines: 1,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Type a message',
                                          prefixIcon: IconButton(
                                            icon: Icon(
                                              Icons.emoji_emotions,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                focusNode.unfocus();
                                                focusNode.canRequestFocus =
                                                    false;
                                                show = !show;
                                              });
                                            },
                                          ),
                                          suffixIcon: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (builder) =>
                                                            bottomSheet());
                                                  },
                                                  icon: Icon(Icons.attach_file,
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      popTime = 2;
                                                    });
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CameraScreen(
                                                                  onImageSend:
                                                                      onImageSend,
                                                                )));
                                                  },
                                                  icon: Icon(Icons.camera_alt,
                                                      color: Theme.of(context)
                                                          .primaryColor))
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.all(5)),
                                    ))),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, right: 5, left: 2),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xFF128C7E),
                                child: IconButton(
                                  onPressed: () {
                                    if (sendButton) {
                                      _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeOut);
                                      sendMessage(
                                          _controller.text,
                                          widget.sourceChat.id ?? 0,
                                          widget.chatModel.id ?? 0,
                                          "");
                                      _controller.clear();
                                      setState(() {
                                        sendButton = false;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    sendButton ? Icons.send : Icons.mic,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        show ? emojiSelect() : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onWillPop: () {
              if (show) {
                setState(() {
                  show = false;
                });
              } else {
                Navigator.pop(context);
              }
              return Future.value(false);
            },
          ),
        ),
      ),
    ]);
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file, Colors.indigo,
                      "Document", () {}),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera", () {
                    setState(() {
                      popTime = 3;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraScreen(
                                  onImageSend: onImageSend,
                                )));
                  }),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery",
                      () async {
                    setState(() {
                      popTime = 2;
                    });
                    file =
                        (await _picker.pickImage(source: ImageSource.gallery))!;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraViewPage(
                                  path: file.path,
                                  onImageSend: onImageSend,
                                )));
                  }),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio", () {}),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                      Icons.location_pin, Colors.teal, "Location", () {}),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact", () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
      IconData icons, Color color, String text, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: EmojiPicker(
        textEditingController:
            _controller,
        config: Config(
          columns: 7,
          emojiSizeMax: 32 *
              (Platform.isIOS
                  ? 1.30
                  : 1.0),
        ),
      ),
    );
  }
}
