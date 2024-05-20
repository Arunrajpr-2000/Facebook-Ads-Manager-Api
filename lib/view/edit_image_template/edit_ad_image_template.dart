// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/components/utils.dart';
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:just_ghar_facebook_post/view/edit_image_template/edit_post_image_template.dart';
import 'package:just_ghar_facebook_post/widgets/drawer_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class EditAdImageTemplate extends StatefulWidget {
  const EditAdImageTemplate({super.key});

  @override
  State<EditAdImageTemplate> createState() => _EditAdImageTemplateState();
}

class _EditAdImageTemplateState extends State<EditAdImageTemplate> {
  TextEditingController feature1Controller = TextEditingController();
  TextEditingController feature2Controller = TextEditingController();
  TextEditingController feature3Controller = TextEditingController();
  TextEditingController feature4Controller = TextEditingController();
  TextEditingController priceMinController = TextEditingController();
  TextEditingController priceMaxController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  String feature1 = "3 BED ROOM";
  String feature2 = "1 LIVING ROOM";
  String feature3 = "KITCHEN";
  String feature4 = "2 BATHROOM";
  String phoneNumber = "88889 88889";
  String price = "77L - 99L";

  Future<bool> _requestStoragePermission() async {
    final storageStatus = await Permission.storage.request();
    return storageStatus == PermissionStatus.granted;
  }

  Future<void> _saveImage() async {
    if (!await _requestStoragePermission()) {
      return;
    }

    // Capture the screenshot with the current state
    final image = await _screenshotController.capture();

    try {
      final directory = await getDownloadsDirectory();
      final dateTime = DateTime.now();
      final fileName = 'image_with_text_$dateTime.png';
      final bytes = image!.buffer.asUint8List();

      await FileSaver.instance.saveAs(
        name: fileName,
        filePath: directory!.path,
        mimeType: MimeType.png,
        bytes: bytes,
        ext: '',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved successfully!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save image!'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    feature1Controller.dispose();
    feature2Controller.dispose();
    feature3Controller.dispose();
    feature4Controller.dispose();
    priceMinController.dispose();
    priceMaxController.dispose();
    phoneNumController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Ad Template",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditPostImageTemplate(),
                  ),
                );
              },
              icon: const Icon(Icons.wallpaper))
        ],
      ),
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/facebook_ad.jpg',
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        left: 10,
                        child: SizedBox(
                          height: 50,
                          child: Image.network(
                              "https://scontent.fblr1-8.fna.fbcdn.net/v/t39.30808-1/309418618_519255106876369_5038763566503765362_n.jpg?stp=dst-jpg_p480x480&_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_ohc=EBdPuuZ2rOwQ7kNvgHjFsON&_nc_ht=scontent.fblr1-8.fna&oh=00_AYBlhuPPFgOdoRbgP1JH04sYBzyZfmrAy0s2N7UDjqzXtw&oe=664B9718"),
                        ),
                      ),
                      Positioned(
                        top: 194,
                        left: 50,
                        child: Text(
                          feature1,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 208,
                          left: 50,
                          child: Text(
                            feature2,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                      Positioned(
                        top: 222,
                        left: 50,
                        child: Text(
                          feature3,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 236,
                          left: 50,
                          child: Text(
                            feature4,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                      Positioned(
                          top: 145,
                          right: 92.5,
                          child: SizedBox(
                            width: 60,
                            child: Text(
                              price,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      Positioned(
                        bottom: 26,
                        left: 42,
                        right: 80,
                        child: Text(
                          "+91 $phoneNumber",
                          style: const TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: feature1Controller,
                        decoration: const InputDecoration(
                          hintText: "Enter Feature 1",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      kheight10,
                      TextField(
                        controller: feature2Controller,
                        decoration: const InputDecoration(
                          hintText: "Enter Feature 2",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      kheight10,
                      TextField(
                        controller: feature3Controller,
                        decoration: const InputDecoration(
                          hintText: "Enter Feature 3",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      kheight10,
                      TextField(
                        controller: feature4Controller,
                        decoration: const InputDecoration(
                          hintText: "Enter Feature 4",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      kheight10,
                      TextField(
                        controller: priceMinController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter Min Price",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      kheight10,
                      TextField(
                        controller: priceMaxController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter Max Price",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      kheight10,
                      TextField(
                        controller: phoneNumController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter phone no",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        feature1 = feature1Controller.text.isEmpty
                            ? feature1
                            : feature1Controller.text;

                        feature2 = feature2Controller.text.isEmpty
                            ? feature2
                            : feature2Controller.text;

                        feature3 = feature3Controller.text.isEmpty
                            ? feature3
                            : feature3Controller.text;

                        feature4 = feature4Controller.text.isEmpty
                            ? feature4
                            : feature4Controller.text;

                        phoneNumber = phoneNumController.text.isEmpty
                            ? phoneNumber
                            : formatPhoneNumber(phoneNumController.text);

                        price = priceMinController.text.isEmpty ||
                                priceMaxController.text.isEmpty
                            ? price
                            : "${getPrice(priceMinController.text)} - ${getPrice(priceMaxController.text)}";
                      });
                    },
                    child: const Text('Save')),
                ElevatedButton(
                    onPressed: _saveImage, child: const Text("Download"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
