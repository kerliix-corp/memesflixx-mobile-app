import 'package:flutter/material.dart';
import '../models/meme.dart';
import '../utils/time_ago.dart';
import '../utils/media_helper.dart';
import 'meme_header.dart';
import 'meme_footer.dart';

class MemeCard extends StatelessWidget {
  final MemeModel meme;

  const MemeCard({super.key, required this.meme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MemeHeader(meme: meme),

        // Media
        AspectRatio(
          aspectRatio: meme.isVideo ? 9 / 16 : 1,
          child: MediaHelper.buildMedia(meme.mediaUrl, meme.isVideo),
        ),

        MemeFooter(meme: meme),

        const Divider(),
      ],
    );
  }
}
