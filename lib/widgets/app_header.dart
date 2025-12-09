import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../app/routes.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const AppHeader({super.key, this.title});

  String _getTitle(BuildContext context) {
    if (title != null) return title!;
    final routeName = ModalRoute.of(context)?.settings.name;
    if (routeTitles.containsKey(routeName)) return routeTitles[routeName]!;
    return "MemesFlixx";
  }

  void _navigate(BuildContext context, String routeName) {
    final current = ModalRoute.of(context)?.settings.name;
    if (current != routeName) Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final headerTitle = _getTitle(context);
    final unread = Provider.of<AuthProvider>(context).unreadCount;

    return AppBar(
      title: Text(headerTitle),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _navigate(context, '/search'),
        ),

        // Notifications with badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => _navigate(context, "/notifications"),
            ),

            if (unread > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unread.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
