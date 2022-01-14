class IronSourceData {
  final String appkey;

  IronSourceData.fromJson(Map<String, dynamic> json)
      : appkey = json['appkey'] ?? "";
}
