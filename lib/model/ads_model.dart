class AdsModel {
  AdsModel({
    this.id,
    required this.name,
    required this.adsetId,
    required this.creative,
    required this.status,
    this.previewShareableLink,
    this.leads,
  });

  final String? id;
  final String? name;
  final String? adsetId;
  final Creative? creative;
  final String? status;
  final String? previewShareableLink;
  final Leads? leads;

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      id: json["id"],
      name: json["name"],
      adsetId: json["adset_id"],
      creative:
          json["creative"] == null ? null : Creative.fromJson(json["creative"]),
      status: json["status"],
      previewShareableLink: json["preview_shareable_link"],
      leads: json["leads"] == null ? null : Leads.fromJson(json["leads"]),
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
    this.name,
    this.objectStorySpec,
  });

  final String? id;
  final String? name;
  final ObjectStorySpec? objectStorySpec;

  factory Creative.fromJson(Map<String, dynamic> json) {
    return Creative(
      id: json["id"],
      name: json["name"],
      objectStorySpec: json["object_story_spec"] == null
          ? null
          : ObjectStorySpec.fromJson(json["object_story_spec"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "object_story_spec": objectStorySpec?.toJson(),
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
    required this.message,
    required this.name,
    required this.description,
  });

  final String? link;
  final String? attachmentStyle;
  final String? imageHash;
  final CallToAction? callToAction;
  final String? message;
  final String? name;
  final String? description;

  factory LinkData.fromJson(Map<String, dynamic> json) {
    return LinkData(
      link: json["link"],
      attachmentStyle: json["attachment_style"],
      imageHash: json["image_hash"],
      callToAction: json["call_to_action"] == null
          ? null
          : CallToAction.fromJson(json["call_to_action"]),
      message: json["message"],
      name: json["name"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
        "link": link,
        "attachment_style": attachmentStyle,
        "image_hash": imageHash,
        "call_to_action": callToAction?.toJson(),
        "message": message,
        "name": name,
        "description": description,
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

class Leads {
  Leads({
    required this.data,
  });

  final List<LeadsDatum> data;

  factory Leads.fromJson(Map<String, dynamic> json) {
    return Leads(
      data: json["data"] == null
          ? []
          : List<LeadsDatum>.from(
              json["data"]!.map((x) => LeadsDatum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x?.toJson()).toList(),
      };
}

class LeadsDatum {
  LeadsDatum({
    required this.createdTime,
    required this.id,
    required this.fieldData,
  });

  final String? createdTime;
  final String? id;
  final List<FieldDatum> fieldData;

  factory LeadsDatum.fromJson(Map<String, dynamic> json) {
    return LeadsDatum(
      createdTime: json["created_time"],
      id: json["id"],
      fieldData: json["field_data"] == null
          ? []
          : List<FieldDatum>.from(
              json["field_data"]!.map((x) => FieldDatum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "created_time": createdTime,
        "id": id,
        "field_data": fieldData.map((x) => x?.toJson()).toList(),
      };
}

class FieldDatum {
  FieldDatum({
    required this.name,
    required this.values,
  });

  final String? name;
  final List<String> values;

  factory FieldDatum.fromJson(Map<String, dynamic> json) {
    return FieldDatum(
      name: json["name"],
      values: json["values"] == null
          ? []
          : List<String>.from(json["values"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "values": values.map((x) => x).toList(),
      };
}
