import 'package:flutter/material.dart';

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
                Container(
                  child: Text("채팅방 $channel"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
