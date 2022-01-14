import 'package:flutter/material.dart';
import 'package:multi_ads/src/data/unity_data.dart';
import 'package:multi_ads/src/networks/ads.dart';
import 'package:multi_ads/src/utils/log.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class UnityAD extends Ads {
  final UnityData _unityData;
  int _bannerIndex = 0;
  int _interIndex = 0;
  int _rewardIndex = 0;

  UnityAD(this._unityData);

  // init
  @override
  Future<void> init() async {
    UnityAds.init(
      gameId: _unityData.gameId,
      listener: (state, args) => Log.log('Init Listener: $state => $args'),
    );
  }

  @override
  Widget getBannerAdWidget(Key key) {
    if (++_bannerIndex >= _unityData.bannerIds.length) {
      _bannerIndex = 0;
    }
    return UnityBannerAd(
      placementId: _unityData.bannerIds[_bannerIndex],
      listener: (state, args) {
        Log.log('Unity Banner Listener: $state => $args');
      },
    );
  }

  @override
  void showInterstitialAd() {
    if (++_interIndex >= _unityData.interIds.length) {
      _interIndex = 0;
    }
    UnityAds.showVideoAd(
      placementId: _unityData.interIds[_interIndex],
      listener: (state, args) => Log.log(
          'Unity Interstitial Video Listener: $state => $args ${_unityData.interIds[_interIndex]}'),
    );
  }

  @override
  void showRewardAd(Function rewarded) {
    if (++_rewardIndex >= _unityData.rewardIds.length) {
      _rewardIndex = 0;
    }
    UnityAds.showVideoAd(
      placementId: _unityData.rewardIds[_rewardIndex],
      listener: (state, args) {
        Log.log(
            'Unity Interstitial Video Listener: $state => $args ${_unityData.rewardIds[_rewardIndex]}');
        if (state == UnityAdState.complete) {
          rewarded();
        }
      },
    );
  }

  @override
  Widget getNativeAdWidget() {
    return Container();
  }

  @override
  Future<void> loadBannerAd(Function? onLoaded, Key key) async {}

  @override
  Future<void> loadInterstitialAd() async {}

  @override
  Future<void> loadRewardAd() async {}

  @override
  Future<void> disposeBanner(Key key) async {}
}
