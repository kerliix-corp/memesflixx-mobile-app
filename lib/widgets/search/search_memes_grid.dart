import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';

class SearchMemesGrid extends StatelessWidget {
  const SearchMemesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context);

    if (search.memes.isEmpty) {
      return const Center(child: Text("No memes found"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: search.memes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, i) {
        final m = search.memes[i];

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            m.mediaUrl,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
