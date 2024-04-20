class AdsetModel {
  AdsetModel({
    this.id,
    required this.name,
    required this.optimizationGoal,
    required this.billingEvent,
    required this.bidAmount,
    required this.dailyBudget,
    required this.campaignId,
    required this.targeting,
    required this.startTime,
    required this.status,
  });

  final String? id;
  final String? name;
  final String? optimizationGoal;
  final String? billingEvent;
  final int? bidAmount;
  final dynamic dailyBudget;
  final String? campaignId;
  final Targeting? targeting;
  final String? startTime;
  final String? status;

  factory AdsetModel.fromJson(Map<String, dynamic> json) {
    return AdsetModel(
      id: json["id"],
      name: json["name"],
      optimizationGoal: json["optimization_goal"],
      billingEvent: json["billing_event"],
      bidAmount: json["bid_amount"],
      dailyBudget: json["daily_budget"],
      campaignId: json["campaign_id"],
      targeting: json["targeting"] == null
          ? null
          : Targeting.fromJson(json["targeting"]),
      startTime: json["start_time"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "optimization_goal": optimizationGoal,
        "billing_event": billingEvent,
        "bid_amount": bidAmount,
        "daily_budget": dailyBudget,
        "campaign_id": campaignId,
        "targeting": targeting?.toJson(),
        "start_time": startTime,
        "status": status,
      };
}

class Targeting {
  Targeting({
    required this.geoLocations,
    required this.interests,
  });

  final GeoLocations? geoLocations;
  final List<Interest> interests;

  factory Targeting.fromJson(Map<String, dynamic> json) {
    return Targeting(
      geoLocations: json["geo_locations"] == null
          ? null
          : GeoLocations.fromJson(json["geo_locations"]),
      interests: json["interests"] == null
          ? []
          : List<Interest>.from(
              json["interests"]!.map((x) => Interest.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "geo_locations": geoLocations?.toJson(),
        "interests": interests.map((x) => x.toJson()).toList(),
      };
}

class GeoLocations {
  GeoLocations({
    required this.countries,
  });

  final List<String> countries;

  factory GeoLocations.fromJson(Map<String, dynamic> json) {
    return GeoLocations(
      countries: json["countries"] == null
          ? []
          : List<String>.from(json["countries"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "countries": countries.map((x) => x).toList(),
      };
}

class Interest {
  Interest({
    required this.id,
    required this.name,
  });

  final dynamic id;
  final String? name;

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
