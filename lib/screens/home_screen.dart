import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_header.dart';
import '../widgets/bottom_navbar.dart';
import '../providers/feed_provider.dart';
import '../widgets/meme_card.dart';
import '../widgets/loading_indicator.dart';
// 1. Import AdProvider and Ad Widgets
import '../providers/ad_provider.dart'; // **Make sure you have this provider setup**
import '../widgets/image_ad_widget.dart'; // **Make sure you have this widget**
import '../widgets/video_ad_widget.dart'; // **Make sure you have this widget**

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

  // Helper function to calculate the number of ads that should be displayed
  int _getAdCount(int totalItems) {
    // An ad is inserted every 5 items, starting after the 5th item.
    // If you have 5 memes, you have 1 ad slot (index 4).
    // If you have 10 memes, you have 2 ad slots (indices 4, 9).
    return totalItems ~/ 5;
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

          // **Calculate Ad/Item Counts**
          final int memeCount = feed.memes.length;
          final int adCount = _getAdCount(memeCount);
          final int totalItems = memeCount + adCount + (feed.isMoreLoading ? 1 : 0);
          
          final adProvider = Provider.of<AdProvider>(context); // **Get AdProvider instance**

          return RefreshIndicator(
            onRefresh: () => feedProvider.loadInitialFeed(),
            child: ListView.builder(
              controller: _scroll,
              // **2. Adjusted itemCount**
              itemCount: totalItems, 
              itemBuilder: (_, i) {
                // Check if the last item is the loading indicator
                if (i == totalItems - 1 && feed.isMoreLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: LoadingIndicator(),
                  );
                }

                // **3. Ad Insertion Logic (Every 5th position, i.e., at index 4, 9, 14, ...)**
                if ((i + 1) % 5 == 0) {
                  // Calculate the ad index.
                  // For i=4, adIndex = 0. For i=9, adIndex = 1.
                  final int adIndex = (i + 1) ~/ 5 - 1; 
                  final ad = adProvider.getAd(adIndex);
                  
                  if (ad != null) {
                    return ad.mediaType == "image"
                        ? ImageAdWidget(ad: ad)
                        : VideoAdWidget(ad: ad);
                  }
                  // Fall through to show the regular meme card if ad is null 
                  // or if you prefer, return a Container() or Spacer() to skip the index.
                  // For this implementation, we will treat the index as a meme index 
                  // if no ad is available to avoid skipping content.
                }
                
                // **Map the list index (i) to the meme index**
                // The current index 'i' includes the space for ads.
                // We need to subtract the number of ads *before* this index to get the correct meme index.
                final int adsBefore = _getAdCount(i);
                final int memeIndex = i - adsBefore;
                
                // Safety check, should not happen if logic is correct
                if (memeIndex >= memeCount) {
                     return const SizedBox.shrink(); 
                }

                return MemeCard(meme: feed.memes[memeIndex]);
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
