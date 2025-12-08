import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();
  UserModel? _user;
  String? _token;
  String? userIdForVerification;

  UserModel? get user => _user;
  String? get token => _token;

  Future<Map<String, dynamic>> identifier(String identifier) async {
    final res = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/identifier"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"identifier": identifier}),
    );

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final res = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"identifier": identifier, "password": password}),
    );

    final body = jsonDecode(res.body);

    if (res.statusCode == 200) {
      _token = body['token'];
      await storage.write(key: "token", value: _token);
      _user = UserModel.fromJson(body['user']);
      notifyListeners();
    }

    return body;
  }

  Future<Map<String, dynamic>> register(String email, String username, String password) async {
    final r = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "username": username,
        "password": password,
      }),
    );

    final body = jsonDecode(r.body);

    if (r.statusCode == 201) {
      userIdForVerification = body["userId"];
    }

    return body;
  }

  Future<Map<String, dynamic>> verifyCode(String code) async {
    final r = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/verify"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userIdForVerification,
        "code": code,
      }),
    );

    final body = jsonDecode(r.body);

    if (r.statusCode == 200) {
      _token = body['token'];
      await storage.write(key: "token", value: _token);
      _user = UserModel.fromJson(body['user']);
      notifyListeners();
    }

    return body;
  }

  Future<bool> setupProfile(String firstName, String lastName, String dob, String sex) async {
    final token = await storage.read(key: "token");

    final r = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob,
        "sex": sex,
      }),
    );

    return r.statusCode == 200;
  }
}
