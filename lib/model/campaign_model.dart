class CampaignModel {
  CampaignModel({
    required this.name,
    required this.objective,
    required this.status,
    required this.specialAdCategories,
    this.id,
  });

  final String? name;
  final String? objective;
  final String? status;
  final List<String> specialAdCategories;
  final String? id;

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      name: json["name"],
      objective: json["objective"],
      status: json["status"],
      specialAdCategories: json["special_ad_categories"] == null
          ? []
          : List<String>.from(json["special_ad_categories"]!.map((x) => x)),
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "objective": objective,
        "status": status,
        "special_ad_categories": specialAdCategories,
      };
}
