import 'package:flutter/material.dart';
import '../models/meme.dart';
import '../services/meme_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// New imports for Comment and Share sheets
import 'share_sheet.dart';
import 'comment_sheet.dart';

class MemeFooter extends StatefulWidget {
  final MemeModel meme;
  const MemeFooter({super.key, required this.meme});

  @override
  State<MemeFooter> createState() => _MemeFooterState();
}

class _MemeFooterState extends State<MemeFooter> {
  bool _liked = false;
  int _likes = 0;

  @override
  void initState() {
    super.initState();
    _liked = widget.meme.liked;
    _likes = widget.meme.likes;
  }

  Future<void> likeMeme() async {
    setState(() {
      _liked = !_liked;
      _likes += _liked ? 1 : -1;
    });

    final token = await const FlutterSecureStorage().read(key: "token");
    await MemeService().likeMeme(widget.meme.id, token!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Like Button Section
        IconButton(
          icon: Icon(_liked ? Icons.favorite : Icons.favorite_border,
              color: _liked ? Colors.red : Colors.grey),
          onPressed: likeMeme,
        ),
        Text("$_likes"),

        const SizedBox(width: 20),

        // Comment Button Section (Replaced Placeholder)
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: () => CommentSheet.open(context, widget.meme.id),
        ),
        Text("${widget.meme.comments}"),

        const SizedBox(width: 20),

        // Share Button Section (New addition)
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => ShareSheet.open(context, widget.meme.mediaUrl),
        ),
        // Assuming your MemeModel has a 'shares' property
        // Text("${widget.meme.shares ?? 0}"), 

        const Spacer(),

        // Views Count
        Text("${widget.meme.views} views"),
      ],
    );
  }
}
