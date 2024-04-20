class AdsModel {
  AdsModel({
    this.id,
    required this.name,
    required this.adsetId,
    required this.creative,
    required this.status,
    this.previewShareableLink,
  });

  final String? id;
  final String? name;
  final String? adsetId;
  final Creative? creative;
  final String? status;
  final String? previewShareableLink;

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      id: json["id"],
      name: json["name"],
      adsetId: json["adset_id"],
      creative:
          json["creative"] == null ? null : Creative.fromJson(json["creative"]),
      status: json["status"],
      previewShareableLink: json["preview_shareable_link"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "adset_id": adsetId,
        "creative": {"creative_id": creative!.id},
        "status": status,
      };
}

class Creative {
  Creative({
    required this.id,
  });

  final String id;

  factory Creative.fromJson(Map<String, dynamic> json) {
    return Creative(
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
