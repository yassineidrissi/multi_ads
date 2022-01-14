class NetworkIndex {
  static final NetworkIndex _networkIndex = NetworkIndex._internal();
  NetworkIndex._internal();

  factory NetworkIndex() {
    return _networkIndex;
  }

  int _bannerIndex = -1;
  int _interIndex = -1;
  int _rewardIndex = -1;
  int _nativeeIndex = -1;

  // getters
  int get bannerIndex => _bannerIndex;
  int get interIndex => _interIndex;
  int get rewardIndex => _rewardIndex;
  int get nativeeIndex => _nativeeIndex;

  void incrementBannerIndex(int length) {
    if (++_bannerIndex >= length) {
      _bannerIndex = 0;
    }
  }

  void incrementInterIndex(int length) {
    if (++_interIndex >= length) {
      _interIndex = 0;
    }
  }

  void incrementRewardIndex(int length) {
    if (++_rewardIndex >= length) {
      _rewardIndex = 0;
    }
  }

  void incrementNativeeIndex(int length) {
    if (++_nativeeIndex >= length) {
      _nativeeIndex = 0;
    }
  }
}
