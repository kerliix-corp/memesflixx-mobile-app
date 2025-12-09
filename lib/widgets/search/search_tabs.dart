import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import 'search_users_list.dart';
import 'search_memes_grid.dart';

class SearchTabs extends StatelessWidget {
  const SearchTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context);

    final tabs = ["Memes", "Users"];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(tabs.length, (i) {
            final selected = search.selectedTab == i;
            return GestureDetector(
              onTap: () => search.setTab(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: selected
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      )
                    : null,
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 10),

        // Results
        Expanded(
          child: search.isLoading
              ? const Center(child: CircularProgressIndicator())
              : search.selectedTab == 0
                  ? const SearchMemesGrid()
                  : const SearchUsersList(),
        ),
      ],
    );
  }
}
