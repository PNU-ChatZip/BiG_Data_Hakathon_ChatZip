import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://tetori.iptime.org:3174/data";

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Future<dynamic> postChats(List<dynamic> chats) async {
    print(chats);
    for (var chat in chats) {
      print(chat);
    }
    // ap dictionary = Map.from(chats[0]);
    // final Pkey = dictionary.keys.toList();
    // final Pvalue = dictionary.values.toList();
    // List<dynamic> answer = [];
    // for (int i = 0; i < Pkey.length; i++) {
    //   answer.add(
    //     {"name": Pkey[i], "comment": Pvalue[i]},
    //   );
    // }
    // print(answer);
    // print(
    //   jsonEncode({
    //     "group_id": 1,
    //     "segment_id": 1,
    //     "data": answer,
    //   }),
    // );
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
