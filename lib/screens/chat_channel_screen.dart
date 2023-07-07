import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';

class ChatChannelScreen extends StatefulWidget {
  const ChatChannelScreen({
    super.key,
  });

  @override
  State<ChatChannelScreen> createState() => _ChatChannelScreenState();
}

class _ChatChannelScreenState extends State<ChatChannelScreen> {
  final List<int> totalChannel = [];
  static List<bool> WhiteList = [];
  // final List<int> totalChannel = [1, 2, 3, 4, 5];
  // static List<bool> WhiteList = [false, false, false, false, false];
  List<ServiceNotificationEvent> events = [];
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  late final SharedPreferences prefs;

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
        setState(() {
          totalChannel.add(channels.length);
          WhiteList.add(false);
        });
      }
    }
    print("현재 저장된 채팅방 갯수: ${channels?.length}");
  }

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

    final int channelCnt = prefs.getStringList('channels')!.length;
    for (var index = 1; index <= channelCnt; index++) {
      totalChannel.add(index);
      WhiteList.add(true);
    }

    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 46, 60, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(46, 46, 60, 1),
        ),
        title: const Text(
          'C H A T  Z I P',
          style: TextStyle(
            color: Color.fromRGBO(46, 46, 60, 1),
            fontWeight: FontWeight.w800,
            fontFamily: 'Noto_Serif',
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var channel in totalChannel)
              ListTile(
                tileColor: const Color.fromRGBO(46, 46, 60, 1),
                title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          channelIndex: channel,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    '✔️   ROOM $channel',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Noto_Serif',
                    ),
                  ),
                ),
                trailing: Switch(
                  activeColor: Colors.white,
                  activeTrackColor: const Color.fromRGBO(124, 251, 95, 1),
                  inactiveTrackColor: const Color.fromRGBO(19, 19, 25, 1),
                  value: WhiteList[channel - 1],
                  onChanged: (bool? value) {
                    // setState(() {
                    //   WhiteList[channel - 1] = value!;
                    // });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
