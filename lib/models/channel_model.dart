import 'chat_model.dart';

class ChannelModel {
  int? id;
  List<ChatModel> chats = [];
  String icon;

  ChannelModel({this.id, required this.icon});

  void appendChat(ChatModel chat) {
    chats.add(chat);
  }

  Map<String, dynamic> toMap() {
    return {
      'data': [for (var chat in chats) chat.toMap()],
    };
  }
}
