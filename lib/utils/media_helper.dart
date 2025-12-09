import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaHelper {
  static Widget buildMedia(String url, bool isVideo) {
    if (!isVideo) {
      return Image.network(url, fit: BoxFit.cover);
    }

    return _VideoPlayer(url);
  }
}

class _VideoPlayer extends StatefulWidget {
  final String url;
  const _VideoPlayer(this.url);

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        controller.setLooping(true);
        controller.play();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}
