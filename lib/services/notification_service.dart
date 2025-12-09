import '../services/api.dart';
import '../models/notification_model.dart';

class NotificationService {
  static Future<List<AppNotification>> fetchNotifications(String token) async {
    final res = await Api.get("/api/notifications", token: token);

    if (res["success"] == true) {
      List list = res["notifications"];
      return list.map((n) => AppNotification.fromJson(n)).toList();
    }

    return [];
  }

  static Future<bool> markRead(String id, String token) async {
    final res = await Api.patch("/api/notifications/$id/read", token: token);
    return res["success"] == true;
  }
}
