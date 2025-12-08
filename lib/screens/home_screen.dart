import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_navbar.dart';
import '../utils/version_checker.dart';
import 'explore_screen.dart';
import 'upload_screen.dart';
import 'friends_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = const [
    Center(child: Text("Home Screen")), // You can replace with your actual Home content
    ExploreScreen(),
    UploadScreen(),
    FriendsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VersionChecker.checkAppVersion(context);
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "MemesFlixx"),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
