import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temp10/services/api_service.dart';

import '../widgets/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  final int channelIndex;

  const ChatScreen({
    super.key,
    required this.channelIndex,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ServiceNotificationEvent> events = [];
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  late final SharedPreferences prefs;
  var result = "";
  List<String> textData = [];
  bool isLoading = false;

  initScreen() async {
    await initPrefs();
    await configSceen();
  }

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var chatData = prefs.getStringList("data${widget.channelIndex}");
    if (chatData != null) print(chatData);
    // final channels = prefs.getStringList('channels');
    // if (channels == null) {
    //   await prefs.setStringList('channels', []);
    // }

    // final whiteList = prefs.getStringList('whiteList');
    // if (whiteList == null) {
    //   await prefs.setStringList('whiteList', []);
    // }
  }

  String convertUint8ListToString(Uint8List uint8list) {
    Uint8List bytes = Uint8List.fromList(uint8list);
    return String.fromCharCodes(bytes);
  }

  void getApiResult() async {
    final channels = prefs.getStringList('channels');
    final idx = channels![widget.channelIndex];
    final chats = prefs.getStringList(idx);
    if (chats!.isEmpty) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext buildcontext) {
            return AlertDialog(
              content: Text("채팅기록이 없습니다"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("확인"),
                )
              ],
            );
          });
      return;
    }
    setState(() {
      isLoading = true;
    });
    final res = await ApiService().postChats(chats);
    print(res);
    getData(res['result']);
    var chatData = prefs.getStringList("data${widget.channelIndex}");
    chatData ??= [];
    chatData.add('${res['datetime']}#FLAG${res['result']}');
    prefs.setStringList("data${widget.channelIndex}", chatData);
    prefs.setStringList(idx, []);
    setState(() {
      isLoading = false;
    });
    configSceen();
  }

  void setTextData() {
    final channels = prefs.getStringList('channels');
    final idx = channels![widget.channelIndex];
    final channel = prefs.getStringList(idx);
    print(channel);
    textData = [];
    for (var t in channel!) {
      Map<String, dynamic> chat = jsonDecode(t);
      print(chat);
      textData.add('${chat['name']}#FLAG${chat['comment']}');
    }
    setState(() {});
  }

  Future configSceen() async {
    final chatData = prefs.getStringList("data${widget.channelIndex}");
    if (chatData != null) {
      textData = [];
      for (var data in chatData) {
        textData.add(data);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  getData(String data) {
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 46, 60, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(46, 46, 60, 1),
        ),
        title: Text(
          'Chat zip 채팅방 ${widget.channelIndex + 1}',
          style: const TextStyle(
            color: Color.fromRGBO(46, 46, 60, 1),
            fontWeight: FontWeight.w800,
            fontFamily: 'Noto_Serif',
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 570,
              width: 400,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: Colors.white,
              //     width: 1,
              //   ),
              // ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  child: getChatsWidgets(textData, isLoading),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      getApiResult();
                    },
                    child: const Text(
                      "요약 보기",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Noto_Serif_KR',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setTextData();
                    },
                    child: const Text(
                      "대화 보기",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Noto_Serif_KR',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(255, 0, 0, 0.7),
                  ),
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            content: const Text("삭제하실 건가요?"),
                            actions: [
                              TextButton(
                                child: const Text("예"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  final channels =
                                      prefs.getStringList('channels');
                                  final idx = channels![widget.channelIndex];
                                  prefs.setStringList(idx, []);
                                  prefs.setStringList(
                                      "data${widget.channelIndex}", []);
                                  configSceen();
                                },
                              ),
                              TextButton(
                                child: const Text("아니요"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "CLEAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                )
              ],
            ),
            // TextButton(
            //   onPressed: () {
            //     setTextData();
            //     // String result = '채팅방 갯수: ';
            //     // final channels = prefs.getStringList('channels');
            //     // result += '${channels!.length}';
            //     // for (var k in channels) {
            //     //   final channel = prefs.getStringList(k);
            //     //   for (var i in channel!) {
            //     //     result += i;
            //     //   }
            //     //   result += '\n\n\n';
            //     // }
            //     // getData(result);
            //   },
            //   child: const Text("채팅 기록 불러오기 딸깍"),
            // ),
          ],
        ),
      ),
    );
  }
}
