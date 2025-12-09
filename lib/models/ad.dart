class AdModel {
  final String id;
  final String mediaUrl;
  final String mediaType; // image | video
  final String? title;
  final String? description;
  final String? actionUrl;
  final String advertiser;

  AdModel({
    required this.id,
    required this.mediaUrl,
    required this.mediaType,
    this.title,
    this.description,
    this.actionUrl,
    required this.advertiser,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json["_id"],
      mediaUrl: json["mediaUrl"],
      mediaType: json["mediaType"],
      title: json["title"],
      description: json["description"],
      actionUrl: json["actionUrl"],
      advertiser: json["advertiser"],
    );
  }
}
