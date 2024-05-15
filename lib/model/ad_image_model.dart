class AdImageModel {
  AdImageModel({
    required this.data,
  });

  final List<AdImageDataModel> data;

  factory AdImageModel.fromJson(Map<String, dynamic> json) {
    return AdImageModel(
      data: json["data"] == null
          ? []
          : List<AdImageDataModel>.from(
              json["data"]!.map((x) => AdImageDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class AdImageDataModel {
  AdImageDataModel({
    required this.id,
    required this.hash,
    required this.url,
    required this.permalinkUrl,
    required this.createdTime,
  });

  final String? id;
  late final String? hash;
  final String? url;
  final String? permalinkUrl;
  final String? createdTime;

  factory AdImageDataModel.fromJson(Map<String, dynamic> json) {
    return AdImageDataModel(
      id: json["id"],
      hash: json["hash"],
      url: json["url"],
      permalinkUrl: json["permalink_url"],
      createdTime: json["created_time"],
    );
  }

  Map<String, dynamic> toJson() => {
        // "id": id,
        "hash": hash,
        "url": url,
        "permalink_url": permalinkUrl,
        "created_time": createdTime,
      };
}
