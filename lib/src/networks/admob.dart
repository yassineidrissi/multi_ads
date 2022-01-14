import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:multi_ads/src/data/admob_data.dart';
import 'package:multi_ads/src/networks/ads.dart';
import 'package:multi_ads/src/utils/log.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart' as native_admob;

class AdmobAD extends Ads {
  final AdmobData _admobData;

  AdmobAD(this._admobData);

  final _banners = <Key, CBannerAd>{};
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _numInterstitialLoadAttempts = 0;
  int _numBannerLoadAttempts = 0;
  int _numRewardedLoadAttempts = 0;
  final int _maxAttempts = 5;

  // init
  @override
  Future<void> init() async {
    await native_admob.MobileAds.initialize();
    await MobileAds.instance.initialize();
  }

  // Banner
  @override
  loadBannerAd(onLoaded, Key key) {
    Log.log("Admob >> banner ID: ");
    Log.log(_admobData.bannerId);
    _banners[key] = CBannerAd(
      isReady: false,
      bannerAd: BannerAd(
        adUnitId: _admobData.bannerId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(onAdLoaded: (_) {
          Log.log('Admob >> banner ad loaded $key');
          _numBannerLoadAttempts = 0;
          _banners[key]?.isReady = true;
          onLoaded!();
        }, onAdFailedToLoad: (ad, err) {
          Log.log('Admob >> Failed to load banner ad $key: ${err.message}');
          ad.dispose();
          _banners[key]?.isReady = false;
          _numBannerLoadAttempts += 1;
          if (_numBannerLoadAttempts <= _maxAttempts) {
            loadBannerAd(onLoaded, key);
          }
        }),
      ),
    );
    return _banners[key]!.bannerAd.load();
  }

  @override
  Widget getBannerAdWidget(Key key) {
    if (!_banners[key]!.isReady) return Container();
    Log.log("Admob >> banner is visible $key");
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: _banners[key]?.bannerAd.size.width.toDouble(),
        height: _banners[key]?.bannerAd.size.height.toDouble(),
        child: AdWidget(ad: _banners[key]!.bannerAd),
      ),
    );
  }

  @override
  Future<void> disposeBanner(Key key) async {
    await _banners[key]?.bannerAd.dispose();
    Log.log("Admob >> Dispose Banner $key");
    _banners[key]?.isReady = false;
  }

  // Interstitial
  @override
  Future<void> loadInterstitialAd() {
    return InterstitialAd.load(
      adUnitId: _admobData.interId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        Log.log('Admob >> $ad loaded');
        _interstitialAd = ad;
        _numInterstitialLoadAttempts = 0;
      }, onAdFailedToLoad: (err) {
        Log.log('Admob >> Failed to load interstitial ad: ${err.message}');
        _numInterstitialLoadAttempts += 1;
        _interstitialAd = null;
        if (_numInterstitialLoadAttempts <= _maxAttempts) loadInterstitialAd();
      }),
    );
  }

  @override
  void showInterstitialAd() {
    if (_interstitialAd == null) {
      Log.log("Admob >> Warning: attempt to show interstitial before loaded.");
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            Log.log('Admob >> $ad onAdShowedFullScreenContent'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          Log.log('Admob >> $ad onAdDismissedFullScreenContent');
          ad.dispose();
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          Log.log('Admob >> $ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          loadInterstitialAd();
        });
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // Reward
  @override
  Future<void> loadRewardAd() {
    return RewardedAd.load(
      adUnitId: _admobData.rewardId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          Log.log('Admob >> $ad loaded.');
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          Log.log('Admob >> RewardedAd failed to load: $error');
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts <= _maxAttempts) {
            loadRewardAd();
          }
        },
      ),
    );
  }

  @override
  void showRewardAd(Function rewarded) {
    if (_rewardedAd == null) {
      Log.log('Admob >> Warning: attempt to show rewarded before loaded.');
      loadRewardAd();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdImpression: (ad) => Log.log('Admob >> onAdImpression'),
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          Log.log('Admob >> ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        Log.log('Admob >> $ad onAdDismissedFullScreenContent.');
        // user rewarded
        rewarded();
        ad.dispose();
        loadRewardAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        Log.log('Admob >> $ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadRewardAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      Log.log(
          'Admob >> $ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
  }

  // Native Ad
  @override
  Widget getNativeAdWidget() {
    return native_admob.NativeAd(
      height: 300,
      buildLayout: native_admob.mediumAdTemplateLayoutBuilder,
      loading: Container(),
      error: Container(),
      unitId: _admobData.nativeId,
    );
  }
}

class CBannerAd {
  bool isReady;
  BannerAd bannerAd;

  CBannerAd({required this.isReady, required this.bannerAd});
}
