import 'dart:convert' show jsonEncode;
import 'dart:io' show File;

import 'package:emojis/emoji.dart';

import '../bin/src/extensions/json_serializable_emoji.dart';

void main() {
  List<Map<String, dynamic>> emojis =
      Emoji.all().map((Emoji emoji) => emoji.toJson()).toList();

  File('emojis.json').writeAsStringSync(jsonEncode(emojis));
}
