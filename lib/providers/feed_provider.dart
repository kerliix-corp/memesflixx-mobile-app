import 'package:flutter/material.dart';
import '../models/meme.dart';
import '../services/meme_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FeedProvider with ChangeNotifier {
  final MemeService _service = MemeService();
  final storage = const FlutterSecureStorage();

  List<MemeModel> memes = [];
  bool isLoading = false;
  bool isMoreLoading = false;
  int page = 1;
  bool endReached = false;

  Future<void> loadInitialFeed() async {
    isLoading = true;
    notifyListeners();

    page = 1;
    endReached = false;

    final token = await storage.read(key: "token");
    final data = await _service.fetchFeed(page, token!);

    memes = (data["memes"] as List)
        .map((e) => MemeModel.fromJson(e))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isMoreLoading || endReached) return;

    isMoreLoading = true;
    notifyListeners();

    page++;
    final token = await storage.read(key: "token");
    final data = await _service.fetchFeed(page, token!);

    final List newMemes =
        data["memes"] ?? [];

    if (newMemes.isEmpty) {
      endReached = true;
    } else {
      memes.addAll(newMemes.map((e) => MemeModel.fromJson(e)));
    }

    isMoreLoading = false;
    notifyListeners();
  }
}
