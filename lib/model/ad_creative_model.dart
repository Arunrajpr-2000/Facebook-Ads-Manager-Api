class AdCreativeDataModel {
  AdCreativeDataModel({
    required this.data,
  });

  final List<AdCreativeModel> data;

  factory AdCreativeDataModel.fromJson(Map<String, dynamic> json) {
    return AdCreativeDataModel(
      data: json["data"] == null
          ? []
          : List<AdCreativeModel>.from(
              json["data"]!.map((x) => AdCreativeModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class AdCreativeModel {
  AdCreativeModel({
    this.id,
    required this.name,
    required this.objectStorySpec,
    this.imageUrl,
    this.imageHash,
    required this.degreesOfFreedomSpec,
  });

  final String? id;
  final String? name;
  final ObjectStorySpec? objectStorySpec;
  final DegreesOfFreedomSpec? degreesOfFreedomSpec;

  final String? imageUrl;
  final String? imageHash;

  factory AdCreativeModel.fromJson(Map<String, dynamic> json) {
    return AdCreativeModel(
      id: json["id"],
      name: json["name"],
      objectStorySpec: json["object_story_spec"] == null
          ? null
          : ObjectStorySpec.fromJson(json["object_story_spec"]),
      imageUrl: json["image_url"],
      imageHash: json["image_hash"],
      degreesOfFreedomSpec: json["degrees_of_freedom_spec"] == null
          ? null
          : DegreesOfFreedomSpec.fromJson(json["degrees_of_freedom_spec"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "object_story_spec": objectStorySpec?.toJson(),
        "degrees_of_freedom_spec": degreesOfFreedomSpec?.toJson(),
      };
}

class DegreesOfFreedomSpec {
  DegreesOfFreedomSpec({
    required this.creativeFeaturesSpec,
  });

  final CreativeFeaturesSpec? creativeFeaturesSpec;

  factory DegreesOfFreedomSpec.fromJson(Map<String, dynamic> json) {
    return DegreesOfFreedomSpec(
      creativeFeaturesSpec: json["creative_features_spec"] == null
          ? null
          : CreativeFeaturesSpec.fromJson(json["creative_features_spec"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "creative_features_spec": creativeFeaturesSpec?.toJson(),
      };
}

class CreativeFeaturesSpec {
  CreativeFeaturesSpec({
    required this.standardEnhancements,
  });

  final StandardEnhancements? standardEnhancements;

  factory CreativeFeaturesSpec.fromJson(Map<String, dynamic> json) {
    return CreativeFeaturesSpec(
      standardEnhancements: json["standard_enhancements"] == null
          ? null
          : StandardEnhancements.fromJson(json["standard_enhancements"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "standard_enhancements": standardEnhancements?.toJson(),
      };
}

class StandardEnhancements {
  StandardEnhancements({
    required this.enrollStatus,
  });

  final String? enrollStatus;

  factory StandardEnhancements.fromJson(Map<String, dynamic> json) {
    return StandardEnhancements(
      enrollStatus: json["enroll_status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "enroll_status": enrollStatus,
      };
}

class ObjectStorySpec {
  ObjectStorySpec({
    required this.pageId,
    required this.instagramActorId,
    required this.linkData,
  });

  final String? pageId;
  final String? instagramActorId;
  final LinkData? linkData;

  factory ObjectStorySpec.fromJson(Map<String, dynamic> json) {
    return ObjectStorySpec(
      pageId: json["page_id"],
      instagramActorId: json["instagram_actor_id"],
      linkData: json["link_data"] == null
          ? null
          : LinkData.fromJson(json["link_data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "page_id": pageId,
        "instagram_actor_id": instagramActorId,
        "link_data": linkData?.toJson(),
      };
}

class LinkData {
  LinkData({
    required this.link,
    required this.attachmentStyle,
    required this.imageHash,
    required this.callToAction,
  });

  final String? link;
  final String? attachmentStyle;
  final String? imageHash;
  final CallToAction? callToAction;

  factory LinkData.fromJson(Map<String, dynamic> json) {
    return LinkData(
      link: json["link"],
      attachmentStyle: json["attachment_style"],
      imageHash: json["image_hash"],
      callToAction: json["call_to_action"] == null
          ? null
          : CallToAction.fromJson(json["call_to_action"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "link": link,
        "attachment_style": attachmentStyle,
        "image_hash": imageHash,
        "call_to_action": callToAction?.toJson(),
      };
}

class CallToAction {
  CallToAction({
    required this.type,
    required this.value,
  });

  final String? type;
  final Value? value;

  factory CallToAction.fromJson(Map<String, dynamic> json) {
    return CallToAction(
      type: json["type"],
      value: json["value"] == null ? null : Value.fromJson(json["value"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value?.toJson(),
      };
}

class Value {
  Value({
    required this.leadGenFormId,
  });

  final String? leadGenFormId;

  factory Value.fromJson(Map<String, dynamic> json) {
    return Value(
      leadGenFormId: json["lead_gen_form_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "lead_gen_form_id": leadGenFormId,
      };
}
