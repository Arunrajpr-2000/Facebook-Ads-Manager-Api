import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/components/utils.dart';
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:just_ghar_facebook_post/model/ad_creative_model.dart';
import 'package:just_ghar_facebook_post/view/ad_creative_screen/add_ad_creative.dart';
import 'package:just_ghar_facebook_post/widgets/drawer_widget.dart';

class AdCreativeListScreen extends StatefulWidget {
  const AdCreativeListScreen({super.key});

  @override
  State<AdCreativeListScreen> createState() => _AdCreativeListScreenState();
}

class _AdCreativeListScreenState extends State<AdCreativeListScreen> {
  List<AdCreativeModel> adCreativeList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAdCreativeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ad Creative"),
        actions: [
          IconButton(
              onPressed: () {
                getAdCreativeList();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddAdcreativeScreen(),
              ));
            },
            icon: const Icon(Icons.add_reaction),
          )
        ],
      ),
      drawer: const DrawerWidget(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              // separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: adCreativeList.length,
              itemBuilder: (context, index) {
                if (adCreativeList[index].imageHash != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          adCreativeList[index].imageUrl ??
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwA8Vgl_Drqz_qUfSKiU9El_JlvsYkdDeClVp3TOB6_w&s",
                        ),
                      ),
                      title: Text(
                        adCreativeList[index].name ?? "No Name",
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        "Hash :${adCreativeList[index].imageHash!}",
                        maxLines: 1,
                      ),
                      trailing: IconButton(
                          onPressed: () async {
                            await showDeleteConfirmationDialog(
                                context, adCreativeList[index].id!);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
    );
  }

  getAdCreativeList() async {
    setState(() {
      isLoading = true;
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
        isLoading = false;
      });

      log(adCreativeList.length.toString());
    } else {
      log(response.statusCode.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteAdCreative(String creativeId, context) async {
    final url = Uri.parse(
        'https://graph.facebook.com/v19.0/$creativeId?access_token=$accessToken');

    final response =
        await http.delete(url, body: {'access_token': accessToken});

    if (response.statusCode == 200) {
      log('Ad creative deleted successfully');
      getAdCreativeList();
    } else {
      snackBarWidget(context, 'Error deleting ad creative: ${response.body}');
      log('Error deleting ad creative: ${response.body}');
    }
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String creativeId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Ad Creative'),
          content:
              const Text('Are you sure you want to delete this ad creative?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // ignore: use_build_context_synchronously
      await deleteAdCreative(creativeId, context);
    }
  }
}
