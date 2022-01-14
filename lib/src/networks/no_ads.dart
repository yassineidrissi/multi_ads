import 'package:flutter/material.dart';
import 'package:multi_ads/src/networks/ads.dart';

class NoAds extends Ads {
  @override
  Future<void> init() async {}

  @override
  Future<void> loadBannerAd(Function? onLoaded, Key key) async {}

  @override
  Future<void> loadInterstitialAd() async {}

  @override
  showInterstitialAd() {}

  @override
  bool get isBannerAdReady => false;

  @override
  bool get isInterstitialAdReady => false;

  @override
  Widget getBannerAdWidget(Key key) => Container();

  @override
  Future<void> disposeBanner(Key key) async {}

  @override
  Widget getNativeAdWidget() {
    return Container();
  }

  @override
  Future<void> loadRewardAd() async {}

  @override
  void showRewardAd(Function rewarded) {}
}
