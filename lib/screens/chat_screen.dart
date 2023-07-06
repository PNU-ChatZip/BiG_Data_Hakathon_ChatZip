import 'package:flutter/material.dart';
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
  var result = "대충 텍스트 슈루룩 화면";

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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(result),
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
              )),
            ],
          ),
        ),
      ),
    );
  }
}
