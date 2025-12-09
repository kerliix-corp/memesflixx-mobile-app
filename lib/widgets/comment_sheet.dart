import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../models/meme.dart';

class CommentSheet {
  static void open(BuildContext context, String memeId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => _CommentSheetContent(memeId: memeId),
    );
  }
}

class _CommentSheetContent extends StatefulWidget {
  final String memeId;

  const _CommentSheetContent({required this.memeId});

  @override
  State<_CommentSheetContent> createState() => _CommentSheetContentState();
}

class _CommentSheetContentState extends State<_CommentSheetContent> {
  final TextEditingController _controller = TextEditingController();
  final storage = const FlutterSecureStorage();

  List comments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/comments/${widget.memeId}"),
    );

    comments = jsonDecode(res.body)["comments"] ?? [];
    loading = false;
    setState(() {});
  }

  Future<void> sendComment() async {
    if (_controller.text.trim().isEmpty) return;

    final token = await storage.read(key: "token");

    await http.post(
      Uri.parse("${ApiConfig.baseUrl}/comments/${widget.memeId}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({"text": _controller.text.trim()}),
    );

    _controller.clear();
    loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 15),
            const Text("Comments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : comments.isEmpty
                      ? const Center(child: Text("No comments yet"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemCount: comments.length,
                          itemBuilder: (_, i) {
                            final c = comments[i];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: c["user"]["avatar"] != null
                                    ? NetworkImage(c["user"]["avatar"])
                                    : null,
                                child: c["user"]["avatar"] == null
                                    ? Text(c["user"]["username"][0])
                                    : null,
                              ),
                              title: Text(c["user"]["username"]),
                              subtitle: Text(c["text"]),
                            );
                          },
                        ),
            ),

            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendComment,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
