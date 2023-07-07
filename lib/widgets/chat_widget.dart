import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getChatsWidgets(List<String> strings) {
  List<Widget> list = [];
  for (var i = 0; i < strings.length; i++) {
    final textFragments = strings[i].split('#FLAG');
    list.add(
      Text(
        textFragments[0],
        style: const TextStyle(color: Colors.red),
      ),
    );

    list.add(
      Text(
        textFragments[1],
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: list,
  );
}
