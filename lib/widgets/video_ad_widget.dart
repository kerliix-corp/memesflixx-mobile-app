import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/ad.dart';
import '../services/ad_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoAdWidget extends StatefulWidget {
  final AdModel ad;

  const VideoAdWidget({super.key, required this.ad});

  @override
  State<VideoAdWidget> createState() => _VideoAdWidgetState();
}

class _VideoAdWidgetState extends State<VideoAdWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _impressionSent = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.ad.mediaUrl)
      ..initialize().then((_) {
        setState(() => _initialized = true);
        _controller.setLooping(true);
        _controller.play();
      });
  }

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
    if (!_initialized) {
      return const SizedBox(
          height: 250, child: Center(child: CircularProgressIndicator()));
    }

    return GestureDetector(
      onTap: _openLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Sponsored • ${widget.ad.advertiser}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
