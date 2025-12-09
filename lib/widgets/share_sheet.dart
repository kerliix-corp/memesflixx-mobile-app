import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ShareSheet {
  static void open(BuildContext context, String memeUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => _ShareSheetContent(memeUrl: memeUrl),
    );
  }
}

class _ShareSheetContent extends StatelessWidget {
  final String memeUrl;

  const _ShareSheetContent({required this.memeUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 240,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Share Meme",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _action(
                  icon: Icons.share,
                  label: "Share",
                  onTap: () {
                    Share.share(memeUrl);
                    Navigator.pop(context);
                  },
                ),
                _action(
                  icon: Icons.copy,
                  label: "Copy Link",
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: memeUrl));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Link copied")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _action({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}
