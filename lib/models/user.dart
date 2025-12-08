class UserModel {
  String id;
  String email;
  String username;
  Map<String, dynamic>? profile;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      profile: json['profile'],
    );
  }
}
