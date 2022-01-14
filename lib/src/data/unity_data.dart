class UnityData {
  final String gameId;
  final List<String> bannerIds;
  final List<String> interIds;
  final List<String> rewardIds;

  UnityData.fromJson(Map<String, dynamic> json)
      : gameId = json["gameId"] ?? "",
        bannerIds = List<String>.from(json["bannerIds"]),
        interIds = List<String>.from(json["interIds"]),
        rewardIds = List<String>.from(json["rewardIds"]);
}
