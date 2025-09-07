import 'package:json_annotation/json_annotation.dart';
part 'forum_post_detail_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum ReactionType {
  @JsonValue('EMPATHY')
  empathy,

  // 서버가 새 타입을 추가해도 안전하게 디코딩하기 위한 기본값
  @JsonValue('UNKNOWN')
  unknown,
}

@JsonSerializable()
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class PostImage {
  final int id;
  final String s3Url;

  PostImage({required this.id, required this.s3Url});

  factory PostImage.fromJson(Map<String, dynamic> json) =>
      _$PostImageFromJson(json);
  Map<String, dynamic> toJson() => _$PostImageToJson(this);
}

/// Map<String,int>  <->  Map<ReactionType,int>
class ReactionCountsConverter
    implements JsonConverter<Map<ReactionType, int>, Map<String, dynamic>?> {
  const ReactionCountsConverter();

  @override
  Map<ReactionType, int> fromJson(Map<String, dynamic>? json) {
    if (json == null) return {};
    final out = <ReactionType, int>{};
    json.forEach((k, v) {
      final rt = $enumDecodeNullable(
            _$ReactionTypeEnumMap,
            k,
            unknownValue: ReactionType.unknown,
          ) ??
          ReactionType.unknown;
      out[rt] = (v as num?)?.toInt() ?? 0;
    });
    return out;
  }

  @override
  Map<String, dynamic> toJson(Map<ReactionType, int> object) {
    final out = <String, dynamic>{};
    object.forEach((k, v) {
      final key = _$ReactionTypeEnumMap[k] ?? 'UNKNOWN';
      out[key] = v;
    });
    return out;
  }
}

/// List<String>  <->  Set<ReactionType>
class ReactionSetConverter
    implements JsonConverter<Set<ReactionType>, List<dynamic>?> {
  const ReactionSetConverter();

  @override
  Set<ReactionType> fromJson(List<dynamic>? json) {
    if (json == null) return {};
    return json
        .map((e) => $enumDecodeNullable(
              _$ReactionTypeEnumMap,
              e,
              unknownValue: ReactionType.unknown,
            )!)
        .toSet();
  }

  @override
  List<String> toJson(Set<ReactionType> object) =>
      object.map((e) => _$ReactionTypeEnumMap[e] ?? 'UNKNOWN').toList();
}

@JsonSerializable(explicitToJson: true)
class ForumPostDetailModel {
  final int id;
  final String title;
  final String content;
  final Category category;
  final String relatedOrganization;
  final List<PostImage> images;
  final String authorNickname;
  final int viewCount;
  final int commentCount;

  @ReactionCountsConverter()
  final Map<ReactionType, int> reactionCounts;

  @ReactionSetConverter()
  final Set<ReactionType> userReactions;

  final DateTime createdAt;
  final DateTime modifiedAt;

  ForumPostDetailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.relatedOrganization,
    required this.images,
    required this.authorNickname,
    required this.viewCount,
    required this.commentCount,
    required this.reactionCounts,
    required this.userReactions,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory ForumPostDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PostDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PostDetailToJson(this);
}
