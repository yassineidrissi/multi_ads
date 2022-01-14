import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:flutter/material.dart';
import 'package:multi_ads/src/data/fan_data.dart';
import 'package:multi_ads/src/networks/ads.dart';
import 'package:multi_ads/src/utils/log.dart';

class FanAD extends Ads {
  final FanData _fanData;
  int _bannerIndex = 0;
  int _interIndex = 0;
  int _rewardIndex = 0;
  int _nativeIndex = 0;
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  final int _maxAttempts = 5;
  int _numInterstitialLoadAttempts = 0;
  int _numRewardedLoadAttempts = 0;
  Function? rewarded;

  FanAD(this._fanData);
  // init
  @override
  Future<void> init() async {}

  // Banner
  @override
  loadBannerAd(onLoaded, Key key) async {}

  @override
  Widget getBannerAdWidget(Key key) {
    if (++_bannerIndex >= _fanData.bannerIds.length) {
      _bannerIndex = 0;
    }
    return FacebookBannerAd(
      placementId: _fanData.bannerIds[_bannerIndex],
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        Log.log(">> FAN > Banner Ad: $result -->  $value");
      },
    );
  }

  @override
  Future<void> disposeBanner(Key key) async {}

  // Interstitial
  @override
  Future<void> loadInterstitialAd() async {
    Log.log(">> FAN > trying to load interstitial ad");
    if (++_interIndex >= _fanData.interIds.length) {
      _interIndex = 0;
    }
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: _fanData.interIds[_interIndex],
      listener: (result, value) {
        Log.log(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
          _numInterstitialLoadAttempts = 0;
        }

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          loadInterstitialAd();
        }

        if (result == InterstitialAdResult.ERROR &&
            ++_numInterstitialLoadAttempts <= _maxAttempts) {
          Log.log(">> FAN > failed to load InterstitialAd");
          loadInterstitialAd();
        }
      },
    );
  }

  @override
  void showInterstitialAd() {
    if (_isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      Log.log(">> FAN > Interstial Ad not yet loaded!");
    }
  }

  // Reward
  @override
  Future<void> loadRewardAd() async {
    if (++_rewardIndex >= _fanData.rewardIds.length) {
      _rewardIndex = 0;
    }
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: _fanData.rewardIds[_rewardIndex],
      listener: (result, value) {
        Log.log(">> FAN > Rewarded Ad: $result --> $value");
        if (result == RewardedVideoAdResult.LOADED) {
          _isRewardedAdLoaded = true;
          _numRewardedLoadAttempts = 0;
        }
        if (result == RewardedVideoAdResult.VIDEO_COMPLETE &&
            rewarded != null) {
          rewarded!();
        }

        if (result == RewardedVideoAdResult.ERROR &&
            ++_numRewardedLoadAttempts <= _maxAttempts) {
          Log.log(">> FAN > failed to load RewardedAd");
          loadRewardAd();
        }
      },
    );
  }

  @override
  void showRewardAd(Function rewarded) {
    this.rewarded = rewarded;
    if (_isRewardedAdLoaded == true) {
      FacebookRewardedVideoAd.showRewardedVideoAd();
    } else {
      Log.log(">> FAN > Rewarded Ad not yet loaded!");
    }
  }

  // Native Ad
  @override
  Widget getNativeAdWidget() {
    if (++_nativeIndex >= _fanData.nativeIds.length) {
      _nativeIndex = 0;
    }
    return FacebookNativeAd(
      placementId: _fanData.nativeIds[_nativeIndex],
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      height: 300,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        Log.log(">> FAN > Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }
}
