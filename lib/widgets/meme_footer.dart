import 'package:flutter/material.dart';
import '../models/meme.dart';
import '../services/meme_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
        IconButton(
          icon: Icon(_liked ? Icons.favorite : Icons.favorite_border,
              color: _liked ? Colors.red : Colors.grey),
          onPressed: likeMeme,
        ),
        Text("$_likes"),

        const SizedBox(width: 20),

        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: () {},
        ),
        Text("${widget.meme.comments}"),

        const Spacer(),

        Text("${widget.meme.views} views"),
      ],
    );
  }
}
