import 'package:flutter/material.dart';

import 'chat_channel_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

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
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatChannelScreen(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                  ),
                  child: Text("카카오톡"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text("추가 예정"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
