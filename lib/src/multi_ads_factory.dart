import 'dart:convert';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:multi_ads/networks.dart';
import 'package:multi_ads/src/data/ads_data.dart';
import 'package:multi_ads/src/globals/networkIndex.dart';
import 'package:multi_ads/src/networks/admob.dart';
import 'package:multi_ads/src/networks/ads.dart';
import 'package:multi_ads/src/networks/applovin.dart';
import 'package:multi_ads/src/networks/fan.dart';
import 'package:multi_ads/src/networks/iron_source.dart';
import 'package:multi_ads/src/networks/no_ads.dart';
import 'package:multi_ads/src/networks/unity.dart';
import 'package:multi_ads/src/utils/log.dart';

class MultiAds {
  late final AdsData adsData;
  late final AdmobAD admobAD;
  late final IronSourceAD ironSourceAD;
  late final ApplovinAD applovinAD;
  late final UnityAD unityAD;
  late final FanAD fanAD;

  final _networks = <String>{};

  void _fillNetworks() {
    adsData.settings.banners.forEach((banner) => _networks.add(banner));
    adsData.settings.inters.forEach((inter) => _networks.add(inter));
    adsData.settings.nativees.forEach((nativee) => _networks.add(nativee));
    adsData.settings.rewards.forEach((reward) => _networks.add(reward));
    Log.log("filled networks: $_networks");
  }

  MultiAds(String json) {
    adsData = AdsData.fromJson(jsonDecode(json));
    admobAD = AdmobAD(adsData.admobData);
    ironSourceAD = IronSourceAD(adsData.ironSourceData);
    applovinAD = ApplovinAD(adsData.applovinData, adsData.settings);
    unityAD = UnityAD(adsData.unityData);
    fanAD = FanAD(adsData.fanData);
    _fillNetworks();
  }

  Future<void> init() async {
    if (_networks.contains(Networks.admob)) {
      await admobAD.init();
    }
    if (_networks.contains(Networks.ironsource)) {
      await ironSourceAD.init();
    }
    if (_networks.contains(Networks.applovin)) {
      await applovinAD.init();
    }
    if (_networks.contains(Networks.unity)) {
      await unityAD.init();
    }
    if (_networks.contains(Networks.fan)) {
      await FacebookAudienceNetwork.init();
    }
  }

  Future<void> loadAds() async {
    for (int i = 0; i < adsData.settings.inters.length; i++) {
      await interInstance.loadInterstitialAd();
    }
    for (int i = 0; i < adsData.settings.rewards.length; i++) {
      await rewardInstance.loadRewardAd();
    }
  }

  Ads get bannerInstance {
    NetworkIndex().incrementBannerIndex(adsData.settings.banners.length);
    if (adsData.settings.banners.isEmpty) {
      return NoAds();
    }
    if (adsData.settings.banners[NetworkIndex().bannerIndex] ==
        Networks.admob) {
      return admobAD;
    }
    if (adsData.settings.banners[NetworkIndex().bannerIndex] ==
        Networks.ironsource) {
      return ironSourceAD;
    }
    if (adsData.settings.banners[NetworkIndex().bannerIndex] ==
        Networks.applovin) {
      return applovinAD;
    }
    if (adsData.settings.banners[NetworkIndex().bannerIndex] ==
        Networks.unity) {
      return unityAD;
    }
    if (adsData.settings.banners[NetworkIndex().bannerIndex] == Networks.fan) {
      return fanAD;
    }
    return NoAds();
  }

  Ads get interInstance {
    NetworkIndex().incrementInterIndex(adsData.settings.inters.length);
    if (adsData.settings.inters.isEmpty) {
      return NoAds();
    }
    if (adsData.settings.inters[NetworkIndex().interIndex] == Networks.admob) {
      return admobAD;
    }
    if (adsData.settings.inters[NetworkIndex().interIndex] ==
        Networks.ironsource) {
      return ironSourceAD;
    }
    if (adsData.settings.inters[NetworkIndex().interIndex] ==
        Networks.applovin) {
      return applovinAD;
    }
    if (adsData.settings.inters[NetworkIndex().interIndex] == Networks.unity) {
      return unityAD;
    }
    if (adsData.settings.inters[NetworkIndex().interIndex] == Networks.fan) {
      return fanAD;
    }
    return NoAds();
  }

  Ads get rewardInstance {
    NetworkIndex().incrementRewardIndex(adsData.settings.rewards.length);
    if (adsData.settings.rewards.isEmpty) {
      return NoAds();
    }
    if (adsData.settings.rewards[NetworkIndex().rewardIndex] ==
        Networks.admob) {
      return admobAD;
    }
    if (adsData.settings.rewards[NetworkIndex().rewardIndex] ==
        Networks.ironsource) {
      return ironSourceAD;
    }
    if (adsData.settings.rewards[NetworkIndex().rewardIndex] ==
        Networks.applovin) {
      return applovinAD;
    }
    if (adsData.settings.rewards[NetworkIndex().rewardIndex] ==
        Networks.unity) {
      return unityAD;
    }
    if (adsData.settings.rewards[NetworkIndex().rewardIndex] == Networks.fan) {
      return fanAD;
    }
    return NoAds();
  }

  Ads get nativeInstance {
    NetworkIndex().incrementNativeeIndex(adsData.settings.nativees.length);
    if (adsData.settings.nativees.isEmpty) {
      return NoAds();
    }
    if (adsData.settings.nativees[NetworkIndex().nativeeIndex] ==
        Networks.admob) {
      return admobAD;
    }
    if (adsData.settings.nativees[NetworkIndex().nativeeIndex] ==
        Networks.ironsource) {
      return ironSourceAD;
    }
    if (adsData.settings.nativees[NetworkIndex().nativeeIndex] ==
        Networks.applovin) {
      return applovinAD;
    }
    if (adsData.settings.nativees[NetworkIndex().nativeeIndex] ==
        Networks.unity) {
      return unityAD;
    }
    if (adsData.settings.nativees[NetworkIndex().nativeeIndex] ==
        Networks.fan) {
      return fanAD;
    }
    return NoAds();
  }
}
