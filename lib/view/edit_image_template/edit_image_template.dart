import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class EditImageTemplate extends StatefulWidget {
  const EditImageTemplate({super.key});

  @override
  State<EditImageTemplate> createState() => _EditImageTemplateState();
}

class _EditImageTemplateState extends State<EditImageTemplate> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  String title = "READY TO SELL ?";
  String subTitle =
      "TAKE ADVANTAGE OF OURFREE APPRAISAL SERVICE.LET'S CHAT TODAY";
  String phoneNumber = "123-456-7890";
  String webSite = "REALLYGREATSITE.COM";

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
      print(error);
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
    titleController.dispose();
    subTitleController.dispose();
    phoneController.dispose();
    siteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Image"),
      ),
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
                        'assets/Simple Real Estate Appraisal Facebook Post no content.png',
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                          top: 30,
                          left: 60,
                          child: SizedBox(
                            width: 190,
                            child: Text(
                              title,
                              style: const TextStyle(fontSize: 40),
                            ),
                          )),
                      Positioned(
                        top: 140,
                        left: 60,
                        child: SizedBox(
                          width: 170,
                          child: Text(
                            subTitle,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 80,
                        right: 80,
                        child: Row(
                          children: [
                            Text(
                              "+ $phoneNumber",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xffb8ae8c),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              webSite,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xffb8ae8c)),
                            ),
                          ],
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
                        controller: titleController,
                        decoration:
                            const InputDecoration(hintText: "Enter title"),
                      ),
                      TextField(
                        controller: subTitleController,
                        decoration:
                            const InputDecoration(hintText: "Enter subtitle"),
                      ),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(hintText: "Enter phone no"),
                      ),
                      TextField(
                        controller: siteController,
                        decoration:
                            const InputDecoration(hintText: "Enter website"),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        title = titleController.text.isEmpty
                            ? title
                            : titleController.text;
                        subTitle = subTitleController.text.isEmpty
                            ? subTitle
                            : subTitleController.text;
                        phoneNumber = phoneController.text.isEmpty
                            ? phoneNumber
                            : phoneController.text;
                        webSite = siteController.text.isEmpty
                            ? webSite
                            : siteController.text;
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
