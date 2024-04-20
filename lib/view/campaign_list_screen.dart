import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:just_ghar_facebook_post/components/alert_dialogue.dart';
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:just_ghar_facebook_post/model/campaign_model.dart';
import 'package:just_ghar_facebook_post/view/adset_list_screen.dart';
import 'dart:developer';

import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

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
                await uploadImage();
              },
              icon: const Icon(Icons.add_a_photo)),
          IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await getCampaigns();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialogWithTextField(
                    title: 'Add Campaign',
                    hintText: 'Enter Campaign name',
                    onSubmit: (name) async {
                      log('Submitted name: $name');
                      setState(() {
                        isLoading = true;
                      });
                      CampaignModel campaignModel = CampaignModel(
                        name: name,
                        objective: "OUTCOME_ENGAGEMENT",
                        status: "ACTIVE",
                        specialAdCategories: ["HOUSING"],
                      );
                      await postCampaign(campaignModel);
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
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final campaign = campaigns[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AdsetListScreen(campaignId: campaign.id.toString()),
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

  Future<void> uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var url = Uri.parse('$adAccBaseUrl/adimages');
      var request = http.MultipartRequest('POST', url);

      // Create a MultipartFile from the picked image file
      var file = await http.MultipartFile.fromPath(
        'filename',
        pickedFile.path,
        contentType:
            MediaType('image', path.extension(pickedFile.path).substring(1)),
      );

      request.fields['access_token'] = accessToken;
      request.files.add(file);

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if the 'images' field exists in the response
        if (responseData.containsKey('images')) {
          var images = responseData['images'];
          if (images is Map) {
            // Iterate over the image objects
            images.forEach((key, value) {
              if (value is Map) {
                final imageData = value;
                log('Uploaded image:');
                log('  Hash: ${imageData['hash']}');
                log('  ID: $key');
                log('  URL: ${imageData['url']}');
                log('  Name: ${imageData['name']}');
              }
            });
          } else {
            log('Unexpected response format: $responseData');
          }
        } else {
          log('No images found in the response: $responseData');
        }
      } else {
        log('Failed to upload image. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');
      }
    } else {
      log('No image selected');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No image selected')));
    }
  }
}
