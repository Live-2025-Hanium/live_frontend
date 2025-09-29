// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumPostCommentModel _$ForumPostCommentModelFromJson(
  Map<String, dynamic> json,
) => ForumPostCommentModel(
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
          ?.map(
            (e) => ForumPostCommentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$ForumPostCommentModelToJson(
  ForumPostCommentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'authorNickname': instance.authorNickname,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'likeCount': instance.likeCount,
  'isLiked': instance.isLiked,
  'isMyComment': instance.isMyComment,
  'replies': instance.replies.map((e) => e.toJson()).toList(),
};
