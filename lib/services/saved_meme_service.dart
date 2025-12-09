import 'package:flutter/material.dart';
import '../models/saved_meme.dart';
import '../services/saved_meme_service.dart';

class SavedMemeProvider with ChangeNotifier {
  List<SavedMeme> _saved = [];

  List<SavedMeme> get saved => _saved;

  Future<void> loadSaved() async {
    _saved = await SavedMemeService.loadSavedMemes();
    notifyListeners();
  }

  Future<void> saveMeme(SavedMeme meme) async {
    await SavedMemeService.saveMeme(meme);
    _saved.add(meme);
    notifyListeners();
  }

  Future<void> unsaveMeme(String memeId) async {
    await SavedMemeService.removeMeme(memeId);
    _saved.removeWhere((m) => m.memeId == memeId);
    notifyListeners();
  }

  Future<bool> isSaved(String memeId) async {
    return SavedMemeService.isSaved(memeId);
  }
}
