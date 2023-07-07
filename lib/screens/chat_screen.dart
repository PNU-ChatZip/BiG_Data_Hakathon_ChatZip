import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temp10/models/chat_model.dart';
import 'package:temp10/services/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ServiceNotificationEvent> events = [];
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  late final SharedPreferences prefs;
  var result = "대충 텍스트 슈루룩 화면";

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final channels = prefs.getStringList('channels');
    if (channels == null) {
      await prefs.setStringList('channels', []);
    }

    final whiteList = prefs.getStringList('whiteList');
    if (whiteList == null) {
      await prefs.setStringList('whiteList', []);
    }
  }

  String convertUint8ListToString(Uint8List uint8list) {
    Uint8List bytes = Uint8List.fromList(uint8list);
    return String.fromCharCodes(bytes);
  }

  void saveEvent(ServiceNotificationEvent event) async {
    // prefs = await SharedPreferences.getInstance();
    final channels = prefs.getStringList('channels');
    if (event.largeIcon != null) {
      final icon = convertUint8ListToString(event.largeIcon!);
      List<String>? channel = prefs.getStringList(icon);
      if (channel != null) {
        print("존재하는 채팅방");
        channel.add({event.title, event.content}.toString());
        prefs.setStringList(icon, channel);
      } else {
        print("없는 채팅방");

        // 새로운 채팅방 추가
        final channels = prefs.getStringList('channels');
        channels!.add(icon);
        prefs.setStringList('channels', channels);
        prefs.setStringList(icon, [event.content!]);

        // whitelist 추가
        final whiteList = prefs.getStringList('whiteList');
        whiteList!.add("false");
      }
    }
    print("현재 저장된 채팅방 갯수: ${channels?.length}");
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    _subscription =
        NotificationListenerService.notificationsStream.listen((event) {
      saveEvent(event);
      setState(() {
        events.add(event);
        print(event);
      });
    });
  }

  getData(String data) {
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat zip'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 500,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(result),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: () async {
                    List<dynamic> chats = [
                      {"name": "kms", "comment": "dasd"},
                      {"name": "ads", "comment": "1223"},
                      {"name": "dds", "comment": "zxvb"}
                    ];
                    final res = await ApiService().postChats(chats);
                    print(res);
                    getData(res.toString());
                  },
                  child: Text("딸깍"),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                String result = '채팅방 갯수: ';
                final channels = prefs.getStringList('channels');
                result += '${channels!.length}';
                for (var k in channels) {
                  final channel = prefs.getStringList(k);
                  for (var i in channel!) {
                    result += i;
                  }
                  result += '\n\n\n';
                }
                getData(result);
              },
              child: const Text("채팅방 딸깍"),
            ),
          ],
        ),
      ),
    );
  }
}
