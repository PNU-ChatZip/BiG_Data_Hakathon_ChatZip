import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';

class ChatChannelScreen extends StatefulWidget {
  const ChatChannelScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatChannelScreen> createState() => _ChatChannelScreenState();
}

class _ChatChannelScreenState extends State<ChatChannelScreen> {
  final List<int> totalChannel = [];
  static List<bool> WhiteList = [];
  List<ServiceNotificationEvent> events = [];
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  late SharedPreferences prefs;

  String convertUint8ListToString(Uint8List uint8list) {
    Uint8List bytes = Uint8List.fromList(uint8list);
    return String.fromCharCodes(bytes);
  }

  void saveEvent(ServiceNotificationEvent event) async {
    final channels = prefs.getStringList('channels');
    if (event.largeIcon != null) {
      final icon = convertUint8ListToString(event.largeIcon!);
      List<String>? channel = prefs.getStringList(icon);
      if (channel != null) {
        print("Existing Chat Room");
        channel.add({event.title, event.content}.toString());
        prefs.setStringList(icon, channel);
      } else {
        print("New Chat Room");

        // Add new chat room
        channels!.add(icon);
        prefs.setStringList('channels', channels);
        prefs.setStringList(icon, [
          {event.title, event.content}.toString()
        ]);

        // Add to whitelist
        final whiteList = prefs.getStringList('whiteList');
        whiteList!.add("false");
        setState(() {
          totalChannel.add(channels.length);
          WhiteList.add(false);
        });
      }
    }
    print("Current number of chat rooms: ${channels?.length}");
  }

  Future<void> initPrefs() async {
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
  void dispose() {
    _subscription?.cancel();
    super.dispose();
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
              if (channel - 1 < WhiteList.length) // Add a check for valid index
                ListTile(
                  tileColor: const Color.fromRGBO(46, 46, 60, 1),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            channelIndex: channel - 1,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.ice_skating),
                        Text(
                          'ROOM $channel',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Noto_Serif',
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: const Color.fromRGBO(124, 251, 95, 1),
                    inactiveTrackColor: const Color.fromRGBO(19, 19, 25, 1),
                    value: WhiteList[channel - 1],
                    onChanged: (bool? value) {
                      setState(() {
                        WhiteList[channel - 1] = value!;
                      });
                      // Update whitelist value in SharedPreferences
                      List<String>? whiteList =
                          prefs.getStringList('whiteList');

                      // Initialize whiteList if it's null or length is less than required
                      if (whiteList == null ||
                          whiteList.length <= channel - 1) {
                        whiteList = List<String>.filled(channel, 'false',
                            growable: true);
                        // Set all values to 'false' as default
                      }

                      whiteList[channel - 1] = value!.toString();
                      prefs.setStringList('whiteList', whiteList);
                      setState(() {});
                      print(whiteList);
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
