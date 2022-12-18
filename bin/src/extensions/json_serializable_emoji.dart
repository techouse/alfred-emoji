import 'package:emojis/emoji.dart';

extension JsonSerializableEmoji on Emoji {
  static final RegExp _tonePattern = RegExp(r'tone\d+');

  Map<String, dynamic> toJson() => {
        'name': name,
        'char': char,
        'shortName': shortName,
        'emojiGroup': emojiGroup.name,
        'emojiSubgroup': emojiSubgroup.name,
        'modifiable': modifiable,
        'variants': shortName
            .split('_')
            .where((String s) => _tonePattern.hasMatch(s))
            .toList(),
        'keywords': keywords,
        'image':
            '${char.runes.map((int i) => i.toRadixString(16)).where((element) => !<String>[
                  '200d',
                  'fe0f',
                ].contains(element)).join('-')}.png',
      };
}
