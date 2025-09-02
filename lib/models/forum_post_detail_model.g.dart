// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) =>
    Category(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

PostImage _$PostImageFromJson(Map<String, dynamic> json) =>
    PostImage(id: (json['id'] as num).toInt(), s3Url: json['s3Url'] as String);

Map<String, dynamic> _$PostImageToJson(PostImage instance) => <String, dynamic>{
  'id': instance.id,
  's3Url': instance.s3Url,
};

PostDetail _$PostDetailFromJson(Map<String, dynamic> json) => PostDetail(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  category: Category.fromJson(json['category'] as Map<String, dynamic>),
  relatedOrganization: json['relatedOrganization'] as String,
  images: (json['images'] as List<dynamic>)
      .map((e) => PostImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  authorNickname: json['authorNickname'] as String,
  viewCount: (json['viewCount'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  reactionCounts: const ReactionCountsConverter().fromJson(
    json['reactionCounts'] as Map<String, dynamic>?,
  ),
  userReactions: const ReactionSetConverter().fromJson(
    json['userReactions'] as List?,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  modifiedAt: DateTime.parse(json['modifiedAt'] as String),
);

Map<String, dynamic> _$PostDetailToJson(
  PostDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'category': instance.category.toJson(),
  'relatedOrganization': instance.relatedOrganization,
  'images': instance.images.map((e) => e.toJson()).toList(),
  'authorNickname': instance.authorNickname,
  'viewCount': instance.viewCount,
  'commentCount': instance.commentCount,
  'reactionCounts': const ReactionCountsConverter().toJson(
    instance.reactionCounts,
  ),
  'userReactions': const ReactionSetConverter().toJson(instance.userReactions),
  'createdAt': instance.createdAt.toIso8601String(),
  'modifiedAt': instance.modifiedAt.toIso8601String(),
};

const _$ReactionTypeEnumMap = {
  ReactionType.empathy: 'EMPATHY',
  ReactionType.unknown: 'UNKNOWN',
};
