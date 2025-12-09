import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/user.dart';
import '../models/meme.dart';
import '../utils/token.dart';

class SearchService {
  static Future<List<MemeModel>> searchMemes(String q) async {
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/search/memes?q=$q"),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    return (body["memes"] as List<dynamic>)
        .map((m) => MemeModel.fromJson(m))
        .toList();
  }

  static Future<List<UserModel>> searchUsers(String q) async {
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/search?q=$q&type=user"),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    return (body["users"] as List<dynamic>)
        .map((u) => UserModel.fromJson(u))
        .toList();
  }

  static Future<List<String>> fetchHistory() async {
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/search/history"),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    return List<String>.from(body.map((h) => h["term"]));
  }

  static Future<void> addHistory(String term) async {
    final token = await TokenStorage.getToken();

    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/search/history"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"term": term}),
    );
  }

  static Future<void> clearHistory() async {
    final token = await TokenStorage.getToken();

    await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/search/history"),
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
