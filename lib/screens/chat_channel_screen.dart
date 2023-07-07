import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ChatChannelScreen extends StatefulWidget {
  const ChatChannelScreen({
    super.key,
  });

  @override
  State<ChatChannelScreen> createState() => _ChatChannelScreenState();
}

class _ChatChannelScreenState extends State<ChatChannelScreen> {
  // 채팅방 갯수
  final List<int> totalChannel = [1, 2, 3, 4, 5];
  static List<bool> WhiteList = [false, false, false, false, false];

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
                        builder: (context) => const ChatScreen(),
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
                    setState(() {
                      WhiteList[channel - 1] = value!;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
