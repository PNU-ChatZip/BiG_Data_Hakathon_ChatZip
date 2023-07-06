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
      appBar: AppBar(
        title: const Text('Chat zip'),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var channel in totalChannel)
                ListTile(
                  tileColor: Colors.yellow[50],
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    },
                    child: Text('채팅방$channel'),
                  ),
                  trailing: Switch(
                    activeColor: Colors.red,
                    value: WhiteList[channel - 1],
                    onChanged: (bool? value) {
                      setState(() {
                        WhiteList[channel - 1] = value!;
                      });
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
