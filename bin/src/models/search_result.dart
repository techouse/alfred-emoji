import 'package:emojis/emoji.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult extends Emoji {
  const SearchResult({
    required this.objectID,
    required super.name,
    required super.char,
    required super.shortName,
    required super.emojiGroup,
    required super.emojiSubgroup,
    super.keywords = const [],
    super.modifiable = false,
    this.image,
  });

  final String objectID;
  final String? image;

  static const List<String> attributesToRetrieve = [
    'name',
    'char',
    'shortName',
    'emojiGroup',
    'emojiSubgroup',
    'keywords',
    'modifiable',
  ];

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}
