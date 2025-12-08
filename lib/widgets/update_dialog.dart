import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final String title;
  final String message;
  final String url;
  final bool force;
  final VoidCallback? onUpdateTapped;
  final VoidCallback? onLaterTapped;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.message,
    required this.url,
    this.force = false,
    this.onUpdateTapped,
    this.onLaterTapped,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () async {
            onUpdateTapped?.call();
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Could not launch update URL")),
              );
            }
          },
          child: const Text('Update'),
        ),
        if (!force)
          TextButton(
            onPressed: () {
              onLaterTapped?.call();
              Navigator.pop(context);
            },
            child: const Text('Later'),
          ),
      ],
    );
  }
}