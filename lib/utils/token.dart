import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await storage.read(key: "token");
  }
}
