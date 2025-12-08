import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_header.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool analyticsEnabled = true;

  String appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: const AppHeader(title: "Settings"),
      body: ListView(
        children: [
          // THEME
          ListTile(
            title: const Text("Theme"),
            subtitle: const Text("Choose your app theme"),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: (mode) {
                if (mode != null) themeProvider.setThemeMode(mode);
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text("System Default"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text("Light"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text("Dark"),
                ),
              ],
            ),
          ),
          const Divider(),

          // NOTIFICATIONS
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: notificationsEnabled,
            onChanged: (val) => setState(() => notificationsEnabled = val),
          ),
          const Divider(),

          // PRIVACY & DATA
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Privacy & Data", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: const Text("Send Analytics"),
            value: analyticsEnabled,
            onChanged: (val) => setState(() => analyticsEnabled = val),
          ),
          ListTile(
            title: const Text("Clear Cache"),
            onTap: () {
              // TODO: Implement cache clearing
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cache cleared")));
            },
          ),
          const Divider(),

          // UPDATES & VERSIONING
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Updates & Versioning", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text("Check for Updates"),
            onTap: () {
              // TODO: Trigger manual version check
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Checking for updates...")));
            },
          ),
          ListTile(
            title: const Text("Latest Version Info"),
            subtitle: Text(appVersion.isNotEmpty ? appVersion : "Loading..."),
          ),
          const Divider(),

          // SUPPORT
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Support", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text("Contact Support"),
            onTap: () {
              launchUrl(Uri.parse("mailto:support@kerliix.com"));
            },
          ),
          ListTile(
            title: const Text("Terms of Service"),
            onTap: () {
              // TODO: Open TOS link
              launchUrl(Uri.parse("https://kerliix.com/terms"));
            },
          ),
          const Divider(),

          // ABOUT
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("About the App", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text("App Version"),
            subtitle: Text(appVersion.isNotEmpty ? appVersion : "Loading..."),
          ),
          ListTile(
            title: const Text("Privacy Policy"),
            onTap: () {
              launchUrl(Uri.parse("https://kerliix.com/privacy"));
            },
          ),
        ],
      ),
    );
  }
}