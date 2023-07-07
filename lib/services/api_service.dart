import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://13.209.41.55/data";

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Future<dynamic> postChats(List<dynamic> chats) async {
    print(chats);
    // for (var chat in chats) {
    //   print(jsonDecode(chat));
    // }
    // ap dictionary = Map.from(chats[0]);
    // final Pkey = dictionary.keys.toList();
    // final Pvalue = dictionary.values.toList();
    List<Map<String, dynamic>> answer = [];
    for (var chat in chats) {
      answer.add(jsonDecode(chat));
    }
    // for (int i = 0; i < Pkey.length; i++) {
    //   answer.add(
    //     {"name": Pkey[i], "comment": Pvalue[i]},
    //   );
    // }
    // print(answer);
    print(
      jsonEncode({
        "group_id": 1,
        "segment_id": 1,
        "data": answer,
      }),
    );
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({
        "group_id": 1,
        "segment_id": 1,
        "data": answer,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
      // return jsonDecode(response.body);
    }
    throw Error();
  }
}
