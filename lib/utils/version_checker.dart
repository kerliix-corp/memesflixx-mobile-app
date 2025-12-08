import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/update_dialog.dart';

/// Version check result status
enum VersionCheckResult {
  upToDate,
  optionalUpdateAvailable,
  forceUpdateRequired,
}

class VersionChecker {
  // Encoded config URL
  static const _encodedUrl =
      'aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2tlcmxpaXgtY29ycC9hcHAtY29uZmlncy9tYWluL21lbWVzZmxpeHgtdXBkYXRlX2NvbmZpZy5qc29u';

  static String get _configUrl => utf8.decode(base64Decode(_encodedUrl));

  /// Main method to check app version and show update dialog if needed
  static Future<VersionCheckResult> checkAppVersion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? data;

    try {
      final res = await http.get(Uri.parse(_configUrl));
      if (res.statusCode == 200) {
        data = jsonDecode(res.body);
        await prefs.setString('cached_version_data', res.body);
        await prefs.setString(
          'cached_hash',
          sha256.convert(utf8.encode(res.body)).toString(),
        );
      }
    } catch (_) {
      final cached = prefs.getString('cached_version_data');
      if (cached != null) data = jsonDecode(cached);
    }

    if (data == null) return VersionCheckResult.upToDate;

    final info = await PackageInfo.fromPlatform();
    final platform =
        Theme.of(context).platform == TargetPlatform.iOS ? 'ios' : 'android';

    final currentVersion = info.version;
    final latest = data[platform]['latestVersion'];
    final minSupported = data[platform]['minSupportedVersion'];
    final updateUrl = data[platform]['updateUrl'];
    final message = data[platform]['message'];

    // Log platform and versions
    print('App version check:');
    print(' - Platform detected: $platform');
    print(' - Current version: $currentVersion');
    print(' - Latest version: $latest');
    print(' - Minimum supported version: $minSupported');

    if (_isVersionLower(currentVersion, minSupported)) {
      print('Showing force update dialog.');
      _showUpdateDialog(context, message, updateUrl, force: true);
      return VersionCheckResult.forceUpdateRequired;
    } else if (_isVersionLower(currentVersion, latest)) {
      print('Showing optional update dialog.');
      _showUpdateDialog(context, message, updateUrl, force: false);
      return VersionCheckResult.optionalUpdateAvailable;
    }

    print('App is up to date.');
    return VersionCheckResult.upToDate;
  }

  /// Compare semantic versions like 1.2.3
  static bool _isVersionLower(String current, String compareTo) {
    final c = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final t = compareTo.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    for (int i = 0; i < 3; i++) {
      final cv = i < c.length ? c[i] : 0;
      final tv = i < t.length ? t[i] : 0;
      if (cv < tv) return true;
      if (cv > tv) return false;
    }
    return false;
  }

  /// Show update dialog — force=true means no "Later" button
  static void _showUpdateDialog(
    BuildContext context,
    String message,
    String url, {
    required bool force,
  }) {
    showDialog(
      barrierDismissible: !force,
      context: context,
      builder: (_) => UpdateDialog(
        title: force ? 'Update Required' : 'Update Available',
        message: message,
        url: url,
        force: force,
        onUpdateTapped: () {
          print('User tapped Update button.');
        },
        onLaterTapped: () {
          if (!force) print('User tapped Later button.');
        },
      ),
    );
  }
}