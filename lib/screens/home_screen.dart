import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_header.dart';
import '../widgets/bottom_navbar.dart';
import '../providers/feed_provider.dart';
import '../widgets/meme_card.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FeedProvider feedProvider;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();

    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    feedProvider.loadInitialFeed();

    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
        feedProvider.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "MemesFlixx"),
      body: Consumer<FeedProvider>(
        builder: (context, feed, _) {
          if (feed.isLoading && feed.memes.isEmpty) {
            return const Center(child: LoadingIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => feedProvider.loadInitialFeed(),
            child: ListView.builder(
              controller: _scroll,
              itemCount: feed.memes.length + (feed.isMoreLoading ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == feed.memes.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: LoadingIndicator(),
                  );
                }

                return MemeCard(meme: feed.memes[i]);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        onTap: (i) {},
      ),
    );
  }
}
