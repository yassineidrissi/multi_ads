class AdmobData {
  final String bannerId;
  final String interId;
  final String nativeId;
  final String rewardId;

  AdmobData.fromJson(Map<String, dynamic> json)
      : bannerId = json['bannerId'] ?? "",
        interId = json['interId'] ?? "",
        nativeId = json['nativeId'] ?? "",
        rewardId = json['rewardId'] ?? "";
}
