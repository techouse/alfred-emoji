import 'package:emojis/emoji.dart';

extension JsonSerializableEmoji on Emoji {
  static final RegExp _tonePattern = RegExp(r'tone\d+');

  Map<String, dynamic> toJson() {
    final List<String> variants = shortName
        .split('_')
        .where((String s) => _tonePattern.hasMatch(s))
        .toList();

    return {
      'objectID': char.runes.map((e) => e.toRadixString(16)).join('-'),
      'name': name,
      'char': char,
      'shortName': shortName,
      'shortNameWithoutVariant': shortName.split('_tone').first,
      'emojiGroup': emojiGroup.name,
      'emojiSubgroup': emojiSubgroup.name,
      'modifiable': modifiable,
      'variants': variants.isNotEmpty ? variants : <String>['tone0'],
      'keywords': keywords,
      'image':
          '${char.runes.map((int i) => i.toRadixString(16)).where((element) => !<String>[
                '200d',
                'fe0f',
              ].contains(element)).join('-')}.png',
    };
  }
}
