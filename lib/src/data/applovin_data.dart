class ApplovinData {
  final String bannerId;
  final String interId;
  final String nativeId;
  final String rewardId;

  ApplovinData.fromJson(Map<String, dynamic> json)
      : bannerId = json['bannerId'] ?? "",
        interId = json['interId'] ?? "",
        nativeId = json['nativeId'] ?? "",
        rewardId = json['rewardId'] ?? "";
}
