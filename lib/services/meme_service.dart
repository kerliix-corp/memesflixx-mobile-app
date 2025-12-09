import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class MemeService {
  Future<Map<String, dynamic>> fetchFeed(int page, String token) async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/memes/feed?page=$page"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(res.body);
  }

  Future<void> likeMeme(String memeId, String token) async {
    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/memes/$memeId/like"),
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
