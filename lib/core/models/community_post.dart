/// Community post model for the hub
/// Simple model without code generation dependencies
class CommunityPost {
  final String id;
  final String? userId;
  final String authorName;
  final String? authorAvatarUrl;
  final String title;
  final String body;
  final String postType;
  final String? tag;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final String? metric1Value;
  final String? metric1Icon;
  final String? metric2Value;
  final String? metric2Icon;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommunityPost({
    required this.id,
    this.userId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.title,
    required this.body,
    this.postType = 'discussion',
    this.tag,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.metric1Value,
    this.metric1Icon,
    this.metric2Value,
    this.metric2Icon,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from Supabase JSON
  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      authorName: json['author_name'] as String? ?? 'Anonymous',
      authorAvatarUrl: json['author_avatar_url'] as String?,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      postType: json['post_type'] as String? ?? 'discussion',
      tag: json['tag'] as String?,
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      sharesCount: json['shares_count'] as int? ?? 0,
      viewsCount: json['views_count'] as int? ?? 0,
      metric1Value: json['metric1_value'] as String?,
      metric1Icon: json['metric1_icon'] as String?,
      metric2Value: json['metric2_value'] as String?,
      metric2Icon: json['metric2_icon'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'author_name': authorName,
      'author_avatar_url': authorAvatarUrl,
      'title': title,
      'body': body,
      'post_type': postType,
      'tag': tag,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'views_count': viewsCount,
      'metric1_value': metric1Value,
      'metric1_icon': metric1Icon,
      'metric2_value': metric2Value,
      'metric2_icon': metric2Icon,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get initials for avatar fallback
  String get authorInitials {
    if (authorName.isEmpty) return '?';
    final parts = authorName.split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return authorName[0].toUpperCase();
  }

  @override
  String toString() {
    return 'CommunityPost(id: $id, author: $authorName, title: $title, type: $postType)';
  }
}
