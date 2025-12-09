class SavedMeme {
  final String memeId;
  final String imageUrl;
  final String caption;
  final DateTime savedAt;

  SavedMeme({
    required this.memeId,
    required this.imageUrl,
    required this.caption,
    required this.savedAt,
  });

  factory SavedMeme.fromJson(Map<String, dynamic> json) {
    return SavedMeme(
      memeId: json['memeId'],
      imageUrl: json['imageUrl'],
      caption: json['caption'],
      savedAt: DateTime.parse(json['savedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "memeId": memeId,
      "imageUrl": imageUrl,
      "caption": caption,
      "savedAt": savedAt.toIso8601String(),
    };
  }
}
