import 'package:flutter/material.dart';
import '../services/search_service.dart';
import '../models/user.dart';
import '../models/meme.dart';

class SearchProvider with ChangeNotifier {
  bool isLoading = false;

  List<UserModel> users = [];
  List<MemeModel> memes = [];
  List<String> history = [];

  int selectedTab = 0; // 0 = memes, 1 = users

  void setTab(int i) {
    selectedTab = i;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    history = await SearchService.fetchHistory();
    notifyListeners();
  }

  Future<void> addHistory(String term) async {
    await SearchService.addHistory(term);
    await loadHistory();
  }

  Future<void> clearHistory() async {
    await SearchService.clearHistory();
    history.clear();
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    isLoading = true;
    notifyListeners();

    memes = await SearchService.searchMemes(query);
    users = await SearchService.searchUsers(query);

    isLoading = false;
    notifyListeners();
  }
}
