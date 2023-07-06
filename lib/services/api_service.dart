import 'dart:convert';

import '../models/chat_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://tetori.iptime.org:3174/data";

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Future<dynamic> postChats(List<dynamic> chats) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({
        "group_id": 1,
        "segment_id": 1,
        "data": chats,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Error();
  }
}
