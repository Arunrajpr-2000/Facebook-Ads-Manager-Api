import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/components/utils.dart';
import 'package:just_ghar_facebook_post/model/ad_creative_model.dart';
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
  bool isLoadingCreative = true;
  List<AdCreativeModel> adCreativeList = [];
  TextEditingController adNameController = TextEditingController();
  String selectedCreativeId = "";

  @override
  void initState() {
    super.initState();
    getAds();
    getAdCreativeList();
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
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 16.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: SizedBox(
                          height: 620,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Add Ads',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: adNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Ad name',
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.black,
                                          width:
                                              1), // Define border color and width
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(selectedCreativeId.isEmpty
                                        ? "Select Creative Id"
                                        : "Creative Id: $selectedCreativeId")),
                                isLoadingCreative
                                    ? const SizedBox(
                                        height: 400,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 400,
                                        child: ListView.builder(
                                          // separatorBuilder: (context, index) => const SizedBox(height: 10),
                                          itemCount: adCreativeList.length,
                                          itemBuilder: (context, index) {
                                            if (adCreativeList[index]
                                                    .imageHash !=
                                                null) {
                                              return GestureDetector(
                                                onTap: () {
                                                  log(adCreativeList[index]
                                                      .id!);
                                                  setState(() {
                                                    selectedCreativeId =
                                                        adCreativeList[index]
                                                            .id!;
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        adCreativeList[index]
                                                                .imageUrl ??
                                                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwA8Vgl_Drqz_qUfSKiU9El_JlvsYkdDeClVp3TOB6_w&s",
                                                      ),
                                                    ),
                                                    title: Text(
                                                      adCreativeList[index]
                                                              .name ??
                                                          "No Name",
                                                      maxLines: 1,
                                                    ),
                                                    subtitle: Text(
                                                        "Hash :${adCreativeList[index].imageHash!}"),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      ),
                                const SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (adNameController.text.isNotEmpty &&
                                        selectedCreativeId.isNotEmpty) {
                                      log("Success");
                                      AdsModel adsModel = AdsModel(
                                        name: adNameController.text,
                                        adsetId: widget.adSetId,
                                        creative:
                                            Creative(id: selectedCreativeId),
                                        status: "ACTIVE",
                                      );
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await postAds(adsModel);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pop(context);

                                      snackBarWidget(
                                          context, "Please fill all fields");
                                    }
                                  },
                                  child: const Text("submit"),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
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

  getAdCreativeList() async {
    setState(() {
      isLoadingCreative = true;
    });
    Uri url = Uri.parse(
        '$adAccBaseUrl/adcreatives?fields=id,name,object_story_spec,image_url,image_hash&limit=300');
    log(url.toString());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final adsImage = data["data"] as List;
      setState(() {
        adCreativeList =
            adsImage.map((json) => AdCreativeModel.fromJson(json)).toList();
        isLoadingCreative = false;
      });

      log(adCreativeList.length.toString());
    } else {
      log(response.statusCode.toString());
      setState(() {
        isLoadingCreative = false;
      });
    }
  }
}
