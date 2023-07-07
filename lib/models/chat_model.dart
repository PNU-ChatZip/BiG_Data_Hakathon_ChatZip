class ChatModel {
  int? id;
  String name;
  String content;

  ChatModel({this.id, required this.name, required this.content});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'content': content,
    };
  }
}
