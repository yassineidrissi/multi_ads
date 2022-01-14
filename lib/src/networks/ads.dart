// ignore_for_file: unused_element, prefer_const_constructors

import 'package:flutter/material.dart';

abstract class Ads {
  Future<void> loadBannerAd(Function? onLoaded, Key key);
  Widget getBannerAdWidget(Key key);
  Future<void> disposeBanner(Key key);

  Future<void> loadInterstitialAd();
  void showInterstitialAd();

  Future<void> loadRewardAd();
  void showRewardAd(Function rewarded);

  Widget getNativeAdWidget();

  Future<void> init();
}
