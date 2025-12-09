class UserShort {
  final String id;
  final String username;
  final String? avatar;

  UserShort({required this.id, required this.username, this.avatar});

  factory UserShort.fromJson(Map<String, dynamic> json) {
    return UserShort(
      id: json["_id"],
      username: json["username"],
      avatar: json["avatar"],
    );
  }
}
