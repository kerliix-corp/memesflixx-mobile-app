import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../models/ad.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdService {
  static final storage = FlutterSecureStorage();

  static Future<List<AdModel>> getFeedAds() async {
    final token = await storage.read(key: "token");

    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/ads/feed"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    final body = jsonDecode(res.body);

    return (body["ads"] as List)
        .map((a) => AdModel.fromJson(a))
        .toList();
  }

  static Future<void> trackImpression(String adId) async {
    final token = await storage.read(key: "token");

    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/ads/impression/$adId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  static Future<void> trackClick(String adId) async {
    final token = await storage.read(key: "token");

    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/ads/click/$adId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
