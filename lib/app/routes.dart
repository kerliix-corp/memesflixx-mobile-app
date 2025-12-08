import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/password_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/verify_email_screen.dart';
import '../screens/auth/profile_setup_screen.dart';
import '../screens/search_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/upload_screen.dart';
import '../screens/friends_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/settings/settings_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/splash': (_) => SplashScreen(),
  '/auth/login': (_) => LoginScreen(),
  '/auth/password': (_) => PasswordScreen(),
  '/auth/register': (_) => RegisterScreen(),
  '/auth/verify-email': (_) => VerifyEmailScreen(),
  '/auth/profile-setup': (_) => ProfileSetupScreen(),
  '/search': (_) => SearchScreen(),
  '/notifications': (_) => NotificationsScreen(),
  '/': (_) => HomeScreen(),
  '/explore': (_) => ExploreScreen(),
  '/upload': (_) => UploadScreen(),
  '/friends': (_) => FriendsScreen(),
  '/profile': (_) => ProfileScreen(),
  '/profile/edit': (_) => EditProfileScreen(),
  '/settings': (_) => SettingsScreen(),
};

final Map<String, String> routeTitles = {
  '/splash': 'Splash',
  '/auth/login': 'Login',
  '/auth/password': 'Enter Your Password',
  '/auth/register': 'Register',
  '/auth/verify-email': 'Verify Email',
  '/auth/profile-setup': 'Profile Setup',
  '/search': 'Search',
  '/notifications': 'Notifications',
  '/': 'Home',
  '/explore': 'Explore',
  '/upload': 'Upload',
  '/friends': 'Friends',
  '/profile': 'Profile',
  '/profile/edit': 'Edit Profile',
  '/settings': 'Settings',
};
