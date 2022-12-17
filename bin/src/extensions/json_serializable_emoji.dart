import 'package:emojis/emoji.dart';

extension JsonSerializableEmoji on Emoji {
  Map<String, dynamic> toJson() => {
        'name': name,
        'char': char,
        'shortName': shortName,
        'emojiGroup': emojiGroup.name,
        'emojiSubgroup': emojiSubgroup.name,
        'modifiable': modifiable,
        'keywords': keywords,
        'image':
            '${char.runes.map((int i) => i.toRadixString(16)).where((element) => !<String>[
                  '200d',
                  'fe0f',
                ].contains(element)).join('-')}.png',
      };
}
