// class LeadFormListModel {
//   LeadFormListModel({
//     required this.data,
//   });

//   final List<LeadFormListData> data;

//   factory LeadFormListModel.fromJson(Map<String, dynamic> json) {
//     return LeadFormListModel(
//       data: json["data"] == null
//           ? []
//           : List<LeadFormListData>.from(
//               json["data"]!.map(
//                 (x) => LeadFormListData.fromJson(x),
//               ),
//             ),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "data": data.map((x) => x.toJson()).toList(),
//       };
// }

// class LeadFormListData {
//   LeadFormListData({
//     required this.id,
//     required this.name,
//     required this.leadsCount,
//   });

//   final String? id;
//   final String? name;
//   final int? leadsCount;

//   factory LeadFormListData.fromJson(Map<String, dynamic> json) {
//     return LeadFormListData(
//       id: json["id"],
//       name: json["name"],
//       leadsCount: json["leads_count"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "leads_count": leadsCount,
//       };
// }

class LeadFormListModel {
  LeadFormListModel({
    required this.data,
  });

  final List<LeadFormListData> data;

  factory LeadFormListModel.fromJson(Map<String, dynamic> json) {
    return LeadFormListModel(
      data: json["data"] == null
          ? []
          : List<LeadFormListData>.from(
              json["data"]!.map((x) => LeadFormListData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class LeadFormListData {
  LeadFormListData(
      {required this.id,
      required this.name,
      required this.leadsCount,
      required this.leads,
      required this.status});

  final String? id;
  final String? name;
  final int? leadsCount;
  final Leads? leads;
  final String? status;

  factory LeadFormListData.fromJson(Map<String, dynamic> json) {
    return LeadFormListData(
      id: json["id"],
      name: json["name"],
      leadsCount: json["leads_count"],
      leads: json["leads"] == null ? null : Leads.fromJson(json["leads"]),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "leads_count": leadsCount,
        "leads": leads?.toJson(),
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
        "data": data.map((x) => x.toJson()).toList(),
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
        "field_data": fieldData.map((x) => x.toJson()).toList(),
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
