import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';

class SearchHistoryWidget extends StatelessWidget {
  final Function(String) onTapTerm;

  const SearchHistoryWidget({super.key, required this.onTapTerm});

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context);

    if (search.history.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Recent searches", style: TextStyle(fontSize: 16)),
            const Spacer(),
            TextButton(
              onPressed: search.clearHistory,
              child: const Text("Clear"),
            )
          ],
        ),
        Wrap(
          spacing: 8,
          children: search.history.map((term) {
            return GestureDetector(
              onTap: () => onTapTerm(term),
              child: Chip(label: Text(term)),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
