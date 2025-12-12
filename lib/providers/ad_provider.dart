import 'package:flutter/material.dart';
import '../models/ad.dart';
import '../services/ad_service.dart';

class AdProvider with ChangeNotifier {
  List<AdModel> ads = [];

  Future<void> loadAds() async {
    ads = await AdService.getFeedAds();
    notifyListeners();
  }

  AdModel? getAd(int index) {
    if (index < ads.length) return ads[index];
    return null;
  }
}
