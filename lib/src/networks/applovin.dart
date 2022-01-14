import 'package:flutter/material.dart';
import 'package:flutter_applovin_max/banner.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';
import 'package:multi_ads/networks.dart';
import 'package:multi_ads/src/data/applovin_data.dart';
import 'package:multi_ads/src/data/settings_data.dart';
import 'package:multi_ads/src/networks/ads.dart';
import 'package:multi_ads/src/utils/log.dart';

class ApplovinAD extends Ads {
  final ApplovinData _applovinData;
  final Settings _settings;

  ApplovinAD(this._applovinData, this._settings);

  bool isRewardedVideoAvailable = false;
  bool isInterstitialVideoAvailable = false;

  void listener(AppLovinAdListener? event) {
    Log.log(">> Applovin > $event");
    if (event == AppLovinAdListener.onUserRewarded) {
      Log.log('>> Applovin > 👍get reward');
    }
  }

  @override
  Future<void> init() async {
    if (_settings.inters.contains(Networks.applovin)) {
      await FlutterApplovinMax.initInterstitialAd(_applovinData.interId);
    }
    if (_settings.rewards.contains(Networks.applovin)) {
      await FlutterApplovinMax.initRewardAd(_applovinData.rewardId);
    }
  }

  // banner
  @override
  Future<void> loadBannerAd(Function? onLoaded, Key key) async {}

  @override
  Widget getBannerAdWidget(Key key) {
    return BannerMaxView(
      (AppLovinAdListener? event) => Log.log(">> Applovin > $event"),
      BannerAdSize.banner,
      _applovinData.bannerId,
    );
  }

  @override
  Future<void> disposeBanner(Key key) async {}

  // native
  @override
  Widget getNativeAdWidget() {
    return Container();
  }

  // inter
  @override
  Future<void> loadInterstitialAd() async {}

  @override
  Future<void> showInterstitialAd() async {
    Log.log(">> Applovin > loading inter");
    isInterstitialVideoAvailable =
        await FlutterApplovinMax.isInterstitialLoaded(listener) ?? false;
    Log.log(">> Applovin > inter loaded");
    if (isInterstitialVideoAvailable) {
      FlutterApplovinMax.showInterstitialVideo(
          (AppLovinAdListener? event) => listener(event));
    }
  }

  // reward
  @override
  Future<void> loadRewardAd() async {}

  @override
  void showRewardAd(Function rewarded) async {
    isRewardedVideoAvailable =
        await FlutterApplovinMax.isRewardLoaded(listener) ?? false;
    Log.log(">> Applovin > loading reward: $isRewardedVideoAvailable");
    if (isRewardedVideoAvailable) {
      FlutterApplovinMax.showRewardVideo((AppLovinAdListener? event) {
        if (event == AppLovinAdListener.onUserRewarded) {
          rewarded();
          Log.log(">> Applovin > user rewarded");
        }
      });
    }
  }
}
