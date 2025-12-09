import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../widgets/search/search_tabs.dart';
import '../widgets/search/search_history.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).loadHistory();
  }

  void _search(String q) {
    if (q.isEmpty) return;

    final searchProv = Provider.of<SearchProvider>(context, listen: false);
    searchProv.addHistory(q);
    searchProv.search(q);
  }

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search MemesFlixx...",
            border: InputBorder.none,
          ),
          onSubmitted: _search,
        ),
      ),
      body: Column(
        children: [
          if (search.memes.isEmpty && search.users.isEmpty)
            SearchHistoryWidget(
              onTapTerm: (term) {
                searchCtrl.text = term;
                _search(term);
              },
            ),

          Expanded(
            child: const SearchTabs(),
          ),
        ],
      ),
    );
  }
}
