import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/components/alert_dialogue.dart';
import 'package:just_ghar_facebook_post/model/ads_model.dart';
import 'package:http/http.dart' as http;
import 'package:just_ghar_facebook_post/core/const.dart';

class AdsListScreen extends StatefulWidget {
  final String adSetId;
  const AdsListScreen({super.key, required this.adSetId});

  @override
  State<AdsListScreen> createState() => _AdsListScreenState();
}

class _AdsListScreenState extends State<AdsListScreen> {
  List<AdsModel> adsModel = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getAds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Facebook Ads'),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await getAds();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                Creative creative = Creative(id: "120207346276350665");
                showDialog(
                  context: context,
                  builder: (context) => AlertDialogWithTextField(
                    title: 'Add Ads',
                    hintText: 'Enter Ad name',
                    onSubmit: (name) async {
                      log('Submitted name: $name');
                      setState(() {
                        isLoading = true;
                      });
                      AdsModel adsModel = AdsModel(
                        name: name,
                        adsetId: widget.adSetId,
                        creative: creative,
                        status: "PAUSED",
                      );
                      await postAds(adsModel);
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: adsModel.length,
                  itemBuilder: (context, index) {
                    final ads = adsModel[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {},
                        tileColor: Colors.white,
                        title: Text(ads.name ?? 'Null'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID : ${ads.id}"),
                            Text('Status: ${ads.status}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> getAds() async {
    final url = Uri.parse(
        '$baseUrl/${widget.adSetId}/ads?fields=id,name,adset_id,creative,status,preview_shareable_link&access_token=$accessToken');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final adSList = data['data'] as List;
      if (mounted) {
        setState(() {
          adsModel = adSList.map((json) => AdsModel.fromJson(json)).toList();
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Error getting ads: Status code ${response.statusCode}';
      });
      log('Error getting ads: ${response.statusCode}');
    }
  }

  Future<void> postAds(AdsModel adsModel) async {
    final url =
        Uri.parse('$adAccBaseUrl/ads?fields=id,name,adset_id,creative,status');
    final body = jsonEncode(adsModel.toJson());

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: body,
    );

    if (response.statusCode == 200) {
      log('Ads created successfully!');
      getAds();
    } else {
      log('Error creating Ads: ${response.statusCode}');
      log(response.body);
      setState(() {
        isLoading = false;
      });
    }
  }
}
