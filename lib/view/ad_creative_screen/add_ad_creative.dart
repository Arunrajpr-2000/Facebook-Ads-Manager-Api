// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/components/utils.dart';
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:just_ghar_facebook_post/model/ad_creative_model.dart';
import 'package:just_ghar_facebook_post/model/ad_image_model.dart';
import 'package:just_ghar_facebook_post/model/lead_form_list_model.dart';
import 'package:just_ghar_facebook_post/view/ad_creative_screen/ad_creative_list_screen.dart';

class AddAdcreativeScreen extends StatefulWidget {
  const AddAdcreativeScreen({super.key});

  @override
  State<AddAdcreativeScreen> createState() => _AddAdcreativeScreenState();
}

class _AddAdcreativeScreenState extends State<AddAdcreativeScreen> {
  TextEditingController nameController = TextEditingController();

  String selectedImageHash = "";
  List<AdImageDataModel> adImageList = [];
  bool isLoading = false;
  bool isLoadingForm = true;
  List<LeadFormListData> leadFormList = [];
  String selectedLeadFormId = "";

  @override
  void initState() {
    super.initState();
    getAdImageList();
    getLeadFormList();
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add AdCreative"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Enter Name',
              ),
            ),
            const SizedBox(height: 30.0),
            //Ad Image Bottom Sheeett ===============+>
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : adImageList.isEmpty
                            ? const Center(child: Text("No Data"))
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                padding: const EdgeInsets.all(16.0),
                                itemCount: adImageList.length,
                                itemBuilder: (context, index) {
                                  final adImage = adImageList[index];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedImageHash = adImage.hash!;
                                      });
                                      log(adImage.hash!);
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      height: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Image.network(
                                            adImage.url ?? '',
                                            fit: BoxFit.contain,
                                            height: 150.0,
                                          ),
                                          Text(
                                            'Hash : ${adImage.hash}',
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                  },
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Colors.black,
                      width: 1), // Define border color and width
                ),
                alignment: Alignment.center,
                child: Text(
                  selectedImageHash.isEmpty
                      ? "Select Image Hash"
                      : "Hash : $selectedImageHash",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            //Lead Gen Form Bottom Sheeett ===============+>
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return isLoadingForm == true
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.black))
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              itemCount: leadFormList.length,
                              itemBuilder: (context, index) {
                                final data = leadFormList[index];
                                if (data.status == "ACTIVE") {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10,
                                        bottom: 5,
                                        top: 10),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          selectedLeadFormId = data.id!;
                                        });
                                        log(selectedLeadFormId);
                                        Navigator.pop(context);
                                      },
                                      tileColor: Colors.white,
                                      title: Text(data.name ?? 'Null'),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("ID : ${data.id}"),
                                          Text('count: ${data.leadsCount}'),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          );
                  },
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Colors.black,
                      width: 1), // Define border color and width
                ),
                alignment: Alignment.center,
                child: Text(
                  selectedLeadFormId.isEmpty
                      ? "Select Lead Form Id"
                      : "Lead Form ID : $selectedLeadFormId",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedImageHash.isNotEmpty &&
                    selectedLeadFormId.isNotEmpty) {
                  AdCreativeModel adCreativeModel = AdCreativeModel(
                    name: nameController.text,
                    objectStorySpec: ObjectStorySpec(
                      pageId: '100464361338965',
                      instagramActorId: '3276684995684196',
                      linkData: LinkData(
                        link: 'http://fb.me/',
                        attachmentStyle: 'link',
                        imageHash: selectedImageHash,
                        callToAction: CallToAction(
                          type: 'APPLY_NOW',
                          value: Value(
                            leadGenFormId: selectedLeadFormId,
                          ),
                        ),
                      ),
                    ),
                    degreesOfFreedomSpec: DegreesOfFreedomSpec(
                      creativeFeaturesSpec: CreativeFeaturesSpec(
                        standardEnhancements:
                            StandardEnhancements(enrollStatus: "OPT_IN"),
                      ),
                    ),
                  );

                  await addAdCreative(adCreativeModel);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const AdCreativeListScreen(),
                  ));
                  log("message");
                } else {
                  snackBarWidget(context, "Please fill all fields");
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  getAdImageList() async {
    setState(() {
      isLoading = true;
    });
    Uri url = Uri.parse(
        '$adAccBaseUrl/adimages?fields=id,hash,url,permalink_url,created_time&limit=200');
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
        adImageList =
            adsImage.map((json) => AdImageDataModel.fromJson(json)).toList();
        isLoading = false;
      });

      log(adImageList.length.toString());
    } else {
      log(response.statusCode.toString());

      setState(() {
        isLoading = false;
      });
      snackBarWidget(context, "Error : ${response.statusCode}");
    }
  }

  Future<void> getLeadFormList() async {
    final url = Uri.parse(
        '$baseUrl/$pageId/leadgen_forms?fields=id,name,leads_count,leads,status');
    final headers = {'Authorization': 'Bearer $pageAccessToken'};
    final response = await http.get(url, headers: headers);
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final leadFormData = LeadFormListModel.fromJson(data).data;

        // log("Data : ${data['data']}");
        setState(() {
          leadFormList = leadFormData;
          isLoadingForm = false;
        });
      } else {
        throw Exception('Error getting lead gen forms: ${response.statusCode}');
      }
    } on Exception catch (error) {
      log('Error getting Form list: $error');

      setState(() {
        isLoadingForm = false;
      });
      snackBarWidget(context, "Error : ${response.statusCode}");
    }
  }

  Future<void> addAdCreative(AdCreativeModel adCreativeModel) async {
    // Prepare the data for the POST request

    // Convert to JSON
    String jsonBody = jsonEncode(adCreativeModel.toJson());

    // Make the POST request
    final response = await http.post(
      Uri.parse('$adAccBaseUrl/adcreatives'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $pageAccessToken',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      // Successful request
      log('Creative added successfully');
      snackBarWidget(context, "Creative added successfully");
    } else {
      // Error handling
      log('Failed to add creative. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
      snackBarWidget(context,
          "Error : ${response.statusCode}, Response body: ${response.body}");
    }
  }
}
