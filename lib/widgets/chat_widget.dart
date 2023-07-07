import 'package:flutter/material.dart';

Widget getChatsWidgets(List<String> strings, bool isLoading) {
  List<Widget> list = [];
  for (var i = 0; i < strings.length; i++) {
    final textFragments = strings[i].split('#FLAG');

    list.add(
      Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Text(
          textFragments[0],
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Noto_Serif',
          ),
        ),
      ),
    );

    list.add(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            textFragments[1],
            style: const TextStyle(
              color: Color.fromRGBO(46, 46, 60, 1),
              fontFamily: 'Noto_Serif_KR',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  list.add(Center(
    child: !isLoading ? const Center() : const CircularProgressIndicator(),
  ));

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: list,
  );
}
