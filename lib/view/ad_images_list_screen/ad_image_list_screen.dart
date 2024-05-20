import 'dart:convert';
import 'dart:developer';
import 'package:just_ghar_facebook_post/view/ad_image_detail_screen/ad_image_detail_screen.dart';
import 'package:just_ghar_facebook_post/widgets/drawer_widget.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:just_ghar_facebook_post/model/ad_image_model.dart';
import 'package:http/http.dart' as http;

class AdImageListScreen extends StatefulWidget {
  const AdImageListScreen({super.key});

  @override
  State<AdImageListScreen> createState() => _AdImageListScreenState();
}

class _AdImageListScreenState extends State<AdImageListScreen> {
  List<AdImageDataModel> adImageList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAdImageList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ad Images',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await uploadImage();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : adImageList.isEmpty
              ? const Center(child: Text("No Data"))
              : ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: adImageList.length,
                  itemBuilder: (context, index) {
                    final adImage = adImageList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AdImageDetailScreen(adImageDataModel: adImage),
                        ));
                        log(adImage.hash!);
                      },
                      child: Card(
                        elevation: 4.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.network(
                              adImage.url ?? '',
                              fit: BoxFit.fill,
                              height: 200.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'ID : ${adImage.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
    }
  }

  Future<void> uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
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
          getAdImageList();
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
