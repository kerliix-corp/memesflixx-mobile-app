import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_meme.dart';
import '../providers/saved_meme_provider.dart';

class SaveButton extends StatefulWidget {
  final String memeId;
  final String imageUrl;
  final String caption;

  const SaveButton({
    super.key,
    required this.memeId,
    required this.imageUrl,
    required this.caption,
  });

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  void _checkSaved() async {
    final provider = Provider.of<SavedMemeProvider>(context, listen: false);
    bool s = await provider.isSaved(widget.memeId);
    setState(() {
      isSaved = s;
    });
  }

  void _toggleSave() async {
    final provider = Provider.of<SavedMemeProvider>(context, listen: false);

    if (isSaved) {
      await provider.unsaveMeme(widget.memeId);
    } else {
      await provider.saveMeme(
        SavedMeme(
          memeId: widget.memeId,
          imageUrl: widget.imageUrl,
          caption: widget.caption,
          savedAt: DateTime.now(),
        ),
      );
    }

    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
      ),
      onPressed: _toggleSave,
    );
  }
}
