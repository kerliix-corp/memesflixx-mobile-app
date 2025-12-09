import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';

class SearchUsersList extends StatelessWidget {
  const SearchUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context);

    if (search.users.isEmpty) {
      return const Center(child: Text("No users found"));
    }

    return ListView.builder(
      itemCount: search.users.length,
      itemBuilder: (context, i) {
        final u = search.users[i];

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(u.profilePicture ?? ""),
          ),
          title: Text(u.username),
          subtitle: Text("${u.firstName} ${u.lastName}"),
        );
      },
    );
  }
}
