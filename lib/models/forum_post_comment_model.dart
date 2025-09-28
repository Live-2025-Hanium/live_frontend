import 'package:json_annotation/json_annotation.dart';

part 'forum_post_comment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ForumPostCommentModel {
  final int id;
  final String content;

  @JsonKey(name: 'authorNickname')
  final String authorNickname;

  final DateTime createdAt;
  final DateTime updatedAt;

  final int likeCount;
  final bool isLiked;

  /// 내가 작성한 댓글 여부
  @JsonKey(name: 'isMyComment')
  final bool isMyComment;

  /// 항상 non-null, 기본값 []
  @JsonKey(defaultValue: [])
  final List<ForumPostCommentModel> replies;

  const ForumPostCommentModel({
    required this.id,
    required this.content,
    required this.authorNickname,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.isLiked,
    required this.isMyComment,
    this.replies = const [],
  });

  factory ForumPostCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ForumPostCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForumPostCommentModelToJson(this);

  ForumPostCommentModel copyWith({
    int? id,
    String? content,
    String? authorNickname,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likeCount,
    bool? isLiked,
    bool? isMyComment,
    List<ForumPostCommentModel>? replies,
  }) {
    return ForumPostCommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      authorNickname: authorNickname ?? this.authorNickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isMyComment: isMyComment ?? this.isMyComment,
      replies: replies ?? this.replies,
    );
  }
}
