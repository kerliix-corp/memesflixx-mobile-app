import 'package:flutter/material.dart';

// Dummy Meme and User models
class Meme {
  final String mediaUrl;
  Meme({required this.mediaUrl});
}

class User {
  final String username;
  final String? profilePicture;
  final String firstName;
  final String lastName;

  User({
    required this.username,
    this.profilePicture,
    required this.firstName,
    required this.lastName,
  });
}

class SearchProvider with ChangeNotifier {
  // Search results
  List<Meme> _memes = [];
  List<User> _users = [];

  // Search history
  List<String> _history = [];

  // UI state
  int _selectedTab = 0;
  bool _isLoading = false;

  // Getters
  List<Meme> get memes => _memes;
  List<User> get users => _users;
  List<String> get history => _history;
  int get selectedTab => _selectedTab;
  bool get isLoading => _isLoading;

  // Set selected tab
  void setTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  // Add a search term to history
  void addHistory(String query) {
    if (!_history.contains(query)) {
      _history.insert(0, query);
      if (_history.length > 10) {
        _history.removeLast(); // keep last 10 searches
      }
      notifyListeners();
    }
  }

  // Clear search history
  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  // Load saved history (dummy for now)
  void loadHistory() {
    // TODO: Load from storage if needed
    _history = [];
    notifyListeners();
  }

  // Perform a search (dummy implementation)
  Future<void> search(String query) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    // Dummy results
    _memes = List.generate(5, (index) => Meme(mediaUrl: "https://placekitten.com/200/300?image=$index"));
    _users = List.generate(5, (index) => User(
      username: "user$index",
      profilePicture: "https://i.pravatar.cc/150?img=$index",
      firstName: "First$index",
      lastName: "Last$index",
    ));

    _isLoading = false;
    notifyListeners();
  }
}
