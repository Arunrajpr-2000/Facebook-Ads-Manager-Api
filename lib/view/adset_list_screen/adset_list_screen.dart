import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/components/alert_dialogue.dart';
import 'package:just_ghar_facebook_post/components/utils.dart';
import 'package:just_ghar_facebook_post/model/adset_model.dart';
import 'package:http/http.dart' as http;
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:just_ghar_facebook_post/view/ads_list_screen/ads_list_screen.dart';

class AdsetListScreen extends StatefulWidget {
  final String campaignId;
  final String campaignObjective;
  const AdsetListScreen(
      {super.key, required this.campaignId, required this.campaignObjective});

  @override
  State<AdsetListScreen> createState() => _AdsetListScreenState();
}

class _AdsetListScreenState extends State<AdsetListScreen> {
  List<AdsetModel> adsetModel = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getAdset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text(
          'Facebook AdSets',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await getAdset();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialogWithTextField(
                    title: 'Add Adset',
                    hintText: 'Enter Adset name',
                    onSubmit: (name) async {
                      log('Submitted name: $name');
                      setState(() {
                        isLoading = true;
                      });
                      final date = DateTime.now();
                      final formattedDateTime = formatDateTime(date);
                      GeoLocations geoLocations =
                          GeoLocations(countries: ["IN"]);
                      Interest interest =
                          Interest(id: 6003139266461, name: "Movies");
                      String optimizationGoal =
                          widget.campaignObjective == "OUTCOME_LEADS"
                              ? "LEAD_GENERATION"
                              : "REACH";
                      log(optimizationGoal);

                      AdsetModel adsetModel = AdsetModel(
                          name: name,
                          optimizationGoal: optimizationGoal,
                          billingEvent: "IMPRESSIONS",
                          bidAmount: 1000,
                          dailyBudget: 10000,
                          campaignId: widget.campaignId,
                          targeting: Targeting(
                              geoLocations: geoLocations,
                              interests: [interest]),
                          startTime: formattedDateTime,
                          status: "ACTIVE",
                          promotedObject: PromotedObject(pageId: pageId));
                      await postAdset(adsetModel);
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : ListView.builder(
              itemCount: adsetModel.length,
              itemBuilder: (context, index) {
                final adset = adsetModel[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AdsListScreen(adSetId: adset.id.toString()),
                        ),
                      );
                    },
                    tileColor: Colors.white,
                    title: Text(adset.name ?? 'Null'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID : ${adset.id}"),
                        Text('Status: ${adset.status}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> getAdset() async {
    final url = Uri.parse(
        '$baseUrl/${widget.campaignId}/adsets?fields=id,bid_amount,name,daily_budget,campaign_id,status,targeting,start_time,billing_event,optimization_goal&access_token=$accessToken');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final adSetList = data['data'] as List;
      setState(() {
        adsetModel =
            adSetList.map((json) => AdsetModel.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      log('Error getting campaigns: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> postAdset(AdsetModel adsetModel) async {
    final url = Uri.parse(
        '$adAccBaseUrl/adsets?fields=bid_amount,name,daily_budget,campaign_id,status,targeting,start_time,billing_event,optimization_goal');

    final body = jsonEncode(adsetModel.toJson());

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: body,
    );

    if (response.statusCode == 200) {
      log('Adset created successfully!');
      getAdset();
    } else {
      log('Error creating Adset: ${response.statusCode}');
      log(response.body);
      setState(() {
        isLoading = false;
      });
    }
  }
}
