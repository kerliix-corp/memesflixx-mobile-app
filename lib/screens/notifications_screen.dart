import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isLoading = true;
  List notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    setState(() => isLoading = true);

    final token = Provider.of<AuthProvider>(context, listen: false).token;

    final res = await Api.get(
      "/api/notifications",
      token: token,
    );

    if (res["success"] == true) {
      setState(() {
        notifications = res["notifications"];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load notifications")),
      );
    }
  }

  Future<void> markAsRead(String id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    await Api.patch("/api/notifications/$id/read", token: token);

    // Update UI instantly
    setState(() {
      notifications = notifications.map((n) {
        if (n["_id"] == id) {
          n["read"] = true;
        }
        return n;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: RefreshIndicator(
        onRefresh: loadNotifications,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? const Center(child: Text("No notifications"))
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];

                      return ListTile(
                        title: Text(
                          notif["title"] ?? "No title",
                          style: TextStyle(
                            fontWeight:
                                notif["read"] == true ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(notif["message"] ?? ""),
                        trailing: notif["read"] == true
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.circle, size: 14, color: Colors.red),

                        onTap: () {
                          if (notif["read"] == false) {
                            markAsRead(notif["_id"]);
                          }
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
