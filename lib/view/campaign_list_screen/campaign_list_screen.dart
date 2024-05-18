import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_ghar_facebook_post/components/alert_dialogue.dart';
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:just_ghar_facebook_post/model/campaign_model.dart';
import 'package:just_ghar_facebook_post/view/adset_list_screen/adset_list_screen.dart';
import 'dart:developer';
import 'package:just_ghar_facebook_post/widgets/drawer_widget.dart';

class FacebookCampaigns extends StatefulWidget {
  const FacebookCampaigns({super.key});

  @override
  State<FacebookCampaigns> createState() => _FacebookCampaignsState();
}

class _FacebookCampaignsState extends State<FacebookCampaigns> {
  List<CampaignModel> campaigns = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCampaigns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Facebook Campaigns'),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await getCampaigns();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialogWithTextField(
                  title: 'Add Campaign',
                  hintText: 'Enter Campaign name',
                  isCampaign: true,
                  onSubmit: (name) async {
                    log('Submitted name: $name');
                    setState(() {
                      isLoading = true;
                    });
                    CampaignModel campaignModel = CampaignModel(
                      name: name,
                      objective: "OUTCOME_LEADS",
                      status: "ACTIVE",
                      specialAdCategories: ["HOUSING"],
                    );
                    await postCampaign(campaignModel);
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const DrawerWidget(),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : ListView.builder(
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final campaign = campaigns[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdsetListScreen(
                          campaignId: campaign.id.toString(),
                          campaignObjective: campaign.objective!,
                        ),
                      ));
                    },
                    tileColor: Colors.white,
                    title: Text(campaign.name ?? 'Null'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID : ${campaign.id}"),
                        Text('Status: ${campaign.status}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> getCampaigns() async {
    final url = Uri.parse(
        '$adAccBaseUrl/campaigns?fields=id,name,objective,status,special_ad_categories&access_token=$accessToken');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final campaignList = data['data'] as List;
      setState(() {
        campaigns = campaignList
            .map((campaign) => CampaignModel.fromJson(campaign))
            .toList();
        isLoading = false;
      });
    } else {
      log('Error getting campaigns: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> postCampaign(CampaignModel campaign) async {
    final url = Uri.parse(
        '$adAccBaseUrl/campaigns?fields=name,special_ad_categories,objective,status');
    final body = jsonEncode(campaign.toJson());

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: body,
    );

    if (response.statusCode == 200) {
      log('Campaign created successfully!');
      getCampaigns();
    } else {
      log('Error creating campaign: ${response.statusCode}');
      log(response.body);
      setState(() {
        isLoading = false;
      });
    }
  }
}
