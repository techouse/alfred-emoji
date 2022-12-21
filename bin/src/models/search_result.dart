import 'package:emojis/emoji.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult extends Emoji {
  const SearchResult({
    required this.objectID,
    required super.name,
    required this.shortNameWithoutVariant,
    required super.char,
    required super.shortName,
    required super.emojiGroup,
    required super.emojiSubgroup,
    required this.variants,
    super.keywords = const [],
    super.modifiable = false,
    this.image,
  });

  final String objectID;
  final String shortNameWithoutVariant;
  final String? image;
  final List<String> variants;

  static const List<String> attributesToRetrieve = [
    'objectID',
    'name',
    'char',
    'shortName',
    'emojiGroup',
    'emojiSubgroup',
    'keywords',
    'modifiable',
    'image',
    'shortNameWithoutVariant',
    'variants',
  ];

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}
