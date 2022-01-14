import 'package:flutter/material.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
import 'package:flutter_ironsource_x/models.dart';
import 'package:multi_ads/src/data/ironsource_data.dart';
import 'package:multi_ads/src/networks/ads.dart';
import 'package:multi_ads/src/utils/log.dart';

class IronSourceBannerAdListener extends IronSourceBannerListener {
  void Function()? onBannerLoaded;

  void Function(Map<String, dynamic>)? onBannerLoadFailed;

  IronSourceBannerAdListener({this.onBannerLoadFailed, this.onBannerLoaded});

  @override
  void onBannerAdLoadFailed(Map<String, dynamic> error) {
    onBannerLoadFailed!(error);
  }

  @override
  void onBannerAdLoaded() {
    onBannerLoaded!();
  }

  @override
  void onBannerAdClicked() {}

  @override
  void onBannerAdLeftApplication() {}

  @override
  void onBannerAdScreenDismissed() {}

  @override
  void onBannerAdScreenPresented() {}
}

class IronSourceAD extends Ads with IronSourceListener {
  final IronSourceData _ironSourceData;
  Function? onRewarded;

  IronSourceAD(this._ironSourceData);

  IronSourceBannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  // init
  @override
  Future<void> init() async {
    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.initialize(
      appKey: _ironSourceData.appkey,
      gdprConsent: true,
      ccpaConsent: false,
      listener: this,
    );
    await IronSource.isRewardedVideoAvailable();
  }

  // Banner
  @override
  Future<void> loadBannerAd(Function? onLoaded, Key key) async {
    _bannerAd = IronSourceBannerAd(
      keepAlive: false,
      listener: IronSourceBannerAdListener(onBannerLoaded: () {
        _isBannerAdReady = true;
        Log.log("onBannerLoaded");
      }, onBannerLoadFailed: (err) {
        _isBannerAdReady = false;
        Log.log("onBannerLoadFailed");
      }),
      size: BannerSize.LARGE,
      backgroundColor: Colors.red,
    );
  }

  @override
  Widget getBannerAdWidget(Key key) {
    if (!_isBannerAdReady) return Container();
    return _bannerAd ?? Container();
  }

  @override
  Future<void> disposeBanner(Key key) async {}

  // Interstitial
  @override
  Future<void> loadInterstitialAd() async {
    return IronSource.loadInterstitial();
  }

  @override
  void showInterstitialAd() async {
    if ((await IronSource.isInterstitialReady())) {
      IronSource.showInterstitial();
    } else {
      Log.log(
        "Interstial is not ready. use 'Ironsource.loadInterstial' before showing it",
      );
    }
  }

  // native
  @override
  Widget getNativeAdWidget() {
    return Container();
  }

  // rewarded
  @override
  Future<void> loadRewardAd() async {
    await IronSource.isRewardedVideoAvailable();
  }

  @override
  void showRewardAd(Function rewarded) async {
    if (await IronSource.isRewardedVideoAvailable()) {
      IronSource.showRewardedVideo();
      onRewarded = rewarded;
    } else {
      Log.log("RewardedVideo not available");
    }
  }

  // Inter listeners
  @override
  void onInterstitialAdClosed() {
    Log.log("onInterstitialAdClosed");
    loadInterstitialAd();
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    Log.log("onInterstitialAdLoadFailed");
    loadInterstitialAd();
  }

  @override
  void onInterstitialAdReady() {
    Log.log("onInterstitialAdReady");
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
    Log.log("onInterstitialAdShowFailed ${error.toString()}");
    loadInterstitialAd();
  }

  // Rewarded listeners
  @override
  void onRewardedVideoAdClicked(Placement placement) {
    Log.log("onRewardedVideoAdClicked");
  }

  @override
  void onRewardedVideoAdClosed() {
    Log.log("onRewardedVideoAdClosed");
  }

  @override
  void onRewardedVideoAdEnded() {
    Log.log("onRewardedVideoAdEnded");
  }

  @override
  void onRewardedVideoAdOpened() {
    Log.log("onRewardedVideoAdOpened");
  }

  @override
  void onRewardedVideoAdRewarded(Placement placement) {
    Log.log("onRewardedVideoAdRewarded: ${placement.placementName}");
    if (onRewarded != null) {
      onRewarded!();
    }
    onRewarded = null;
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
    Log.log("onRewardedVideoAdShowFailed : ${error.toString()}");
  }

  @override
  void onRewardedVideoAdStarted() {
    Log.log("onRewardedVideoAdStarted");
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool available) {
    Log.log("onRewardedVideoAvailabilityChanged : $available");
  }

  // Offerwall listeners
  @override
  void onGetOfferwallCreditsFailed(IronSourceError error) {}

  @override
  void onInterstitialAdClicked() {}

  @override
  void onInterstitialAdOpened() {}

  @override
  void onInterstitialAdShowSucceeded() {}

  @override
  void onOfferwallAdCredited(OfferwallCredit reward) {}

  @override
  void onOfferwallAvailable(bool available) {}

  @override
  void onOfferwallClosed() {}

  @override
  void onOfferwallOpened() {}

  @override
  void onOfferwallShowFailed(IronSourceError error) {}
}
