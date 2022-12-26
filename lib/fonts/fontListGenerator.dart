import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'icons.dart';

// static const IconData zoom_out_map = IconData(0xe6ff, fontFamily: 'MaterialIcons');
//
//Map maFontsMap = <String, Map<String, String>>{
//  "keybella": <String, String>{
//    "font name": "arial",
//    "fonct code": "pippo",
//  },
//};

main() {
  var path = "/flutter/packages/flutter/lib/src/material/icons.dart";
  var writer = new File("meFontMap.dart").openWrite(mode: FileMode.write);

  writer.write('Map maFontsMap = <String, Map<String, dynamic>>{ \n');

  new File(path)
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .forEach((l) {
    RegExp regExp = new RegExp(
      r"(static const IconData )(\w+)(?: = IconData\()([^,]+)(, fontFamily: ')(\w+)",
      caseSensitive: false,
      multiLine: false,
    );

    Iterable<RegExpMatch> matches = regExp.allMatches(l);

    if (matches.length > 0) {
      writer.write(
          '"${matches.elementAt(0).group(2)}" : <String, dynamic>{\n "codepoint":${matches.elementAt(0).group(3)}, \n "fontfamily":"${matches.elementAt(0).group(5)}"},\n');
    }
  }).whenComplete(() => writer.write('};'));

  print(maFontsMap['keybella']['fontfamily']);
}
