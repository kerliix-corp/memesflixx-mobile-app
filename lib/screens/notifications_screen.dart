import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/api.dart';
import '../../providers/auth_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool loading = true;
  List notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = auth.token;

    if (token == null) return;

    setState(() => loading = true);

    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/notifications"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      notifications = body["notifications"] ?? [];

      // update unread count from backend list
      final unread = notifications.where((n) => n["read"] == false).length;
      auth.setUnreadCount(unread);
    }

    setState(() => loading = false);
  }

  Future<void> _markAsRead(notifId) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = auth.token;

    await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/notifications/$notifId/read"),
      headers: {"Authorization": "Bearer $token"},
    );

    // Update UI immediately
    final index = notifications.indexWhere((n) => n["_id"] == notifId);
    if (index != -1) {
      notifications[index]["read"] = true;
    }

    // Update global unread count
    final unread = notifications.where((n) => !n["read"]).length;
    auth.setUnreadCount(unread);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              child: notifications.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 200),
                        Center(child: Text("No notifications yet")),
                      ],
                    )
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, i) {
                        final n = notifications[i];
                        final isUnread = n["read"] == false;

                        return InkWell(
                          onTap: () => _markAsRead(n["_id"]),
                          child: Container(
                            color: isUnread
                                ? Colors.blue.withOpacity(0.05)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            child: Row(
                              children: [
                                // Unread dot
                                if (isUnread)
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                else
                                  const SizedBox(width: 20),

                                // Texts
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        n["title"] ?? "",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isUnread
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        n["message"] ?? "",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
