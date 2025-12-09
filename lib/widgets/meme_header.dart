import 'package:flutter/material.dart';
import '../models/meme.dart';
import '../utils/time_ago.dart';

class MemeHeader extends StatelessWidget {
  final MemeModel meme;
  const MemeHeader({super.key, required this.meme});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            meme.user.avatar != null ? NetworkImage(meme.user.avatar!) : null,
        child: meme.user.avatar == null ? Text(meme.user.username[0]) : null,
      ),
      title: Text(meme.user.username),
      subtitle: Text(TimeAgo.format(meme.createdAt)),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
    );
  }
}
