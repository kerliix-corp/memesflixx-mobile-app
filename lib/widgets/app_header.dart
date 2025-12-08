import 'package:flutter/material.dart';
import '../app/routes.dart'; // import routeTitles

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // optional manual title override

  const AppHeader({super.key, this.title});

  // Get title: manual override first, else from current route
  String _getTitle(BuildContext context) {
    if (title != null) return title!;
    final routeName = ModalRoute.of(context)?.settings.name;
    if (routeName != null && routeTitles.containsKey(routeName)) {
      return routeTitles[routeName]!;
    }
    return 'MemesFlixx'; // fallback title
  }

  void _navigate(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerTitle = _getTitle(context);

    return AppBar(
      title: Text(headerTitle),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => _navigate(context, '/search'),
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          tooltip: 'Notifications',
          onPressed: () => _navigate(context, '/notifications'),
        ),
        // Profile button removed
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
