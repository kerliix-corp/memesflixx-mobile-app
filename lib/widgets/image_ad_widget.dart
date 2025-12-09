import 'package:flutter/material.dart';
import '../models/ad.dart';
import '../services/ad_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageAdWidget extends StatefulWidget {
  final AdModel ad;

  const ImageAdWidget({super.key, required this.ad});

  @override
  State<ImageAdWidget> createState() => _ImageAdWidgetState();
}

class _ImageAdWidgetState extends State<ImageAdWidget> {
  bool _impressionSent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_impressionSent) {
      AdService.trackImpression(widget.ad.id);
      _impressionSent = true;
    }
  }

  void _openLink() async {
    if (widget.ad.actionUrl != null) {
      await AdService.trackClick(widget.ad.id);
      launchUrl(Uri.parse(widget.ad.actionUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: _openLink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.ad.mediaUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.ad.title ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(widget.ad.description ?? ""),
                  const SizedBox(height: 10),
                  Text(
                    "Sponsored • ${widget.ad.advertiser}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
