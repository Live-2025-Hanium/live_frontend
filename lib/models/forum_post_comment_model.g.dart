// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumPostComment _$ForumPostCommentFromJson(Map<String, dynamic> json) =>
    ForumPostComment(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      authorNickname: json['authorNickname'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      likeCount: (json['likeCount'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
      isMyComment: json['isMyComment'] as bool,
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ForumPostCommentToJson(ForumPostComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'authorNickname': instance.authorNickname,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'likeCount': instance.likeCount,
      'isLiked': instance.isLiked,
      'isMyComment': instance.isMyComment,
      'replies': instance.replies,
    };
