// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static const String baseUrl = "http://13.209.41.55/data";
//
//   Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//   };
//
//   Map<String, String> cookies = {};
//
//   Future<dynamic> postChats(List<dynamic> chats) async {
//     print(chats);
//     List<Map<String, dynamic>> answer = [];
//     for (var chat in chats) {
//       answer.add(jsonDecode(chat));
//       print(answer);
//     }
//     print(
//       jsonEncode({
//         "group_id": 1,
//         "segment_id": 1,
//         "data": answer,
//       }),
//     );
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: headers,
//       body: jsonEncode({
//         "group_id": 1,
//         "segment_id": 1,
//         "data": answer,
//       }),
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(utf8.decode(response.bodyBytes));
//       // return jsonDecode(response.body);
//     }
//     throw Error();
//   }
// }
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://13.209.41.55/data";
  // static const String baseUrl = "http://tetori.iptime.org:3174/data";

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Map<String, String> OriToNew = {};
  Map<String, String> NewToOri = {};

  Future<dynamic> postChats(List<dynamic> chats) async {
    List<Map<String, dynamic>> answer = [];
    for (var chat in chats) {
      var counter = OriToNew.length;
      Map<String, dynamic> chatDecoded = jsonDecode(chat);
      String original = chatDecoded['name'];
      String newName = 'P$counter';
      if (OriToNew.containsKey(original)) {
        newName = OriToNew[original]!;
      } else {
        OriToNew[original] = newName;
        NewToOri[newName] = original;
      }
      chatDecoded['name'] = newName;
      answer.add(chatDecoded);
      print(answer);
    }
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
      Map<String, dynamic> responseDecoded =
          jsonDecode(utf8.decode(response.bodyBytes));
      for (int i = 0; i < NewToOri.length; i++) {
        int th = i;
        responseDecoded['result'] = responseDecoded['result']
            .toString()
            .replaceAll('P$th', NewToOri['P$th']!);
      }
      return (responseDecoded);
      // return jsonDecode(response.body);
    }
    throw Error();
  }
}
