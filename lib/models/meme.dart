import 'user_short.dart';

class MemeModel {
  final String id;
  final UserShort user;
  final String mediaUrl;
  final bool isVideo;
  final int likes;
  final int comments;
  final int views;
  final bool liked;
  final DateTime createdAt;

  MemeModel({
    required this.id,
    required this.user,
    required this.mediaUrl,
    required this.isVideo,
    required this.likes,
    required this.comments,
    required this.views,
    required this.liked,
    required this.createdAt,
  });

  factory MemeModel.fromJson(Map<String, dynamic> json) {
    return MemeModel(
      id: json["_id"],
      user: UserShort.fromJson(json["user"]),
      mediaUrl: json["mediaUrl"],
      isVideo: json["isVideo"],
      likes: json["likesCount"] ?? 0,
      comments: json["commentsCount"] ?? 0,
      views: json["viewsCount"] ?? 0,
      liked: json["liked"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
